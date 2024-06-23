import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/string_util.dart';

class SelectedQuarterModulesScreen extends ConsumerStatefulWidget {
  final int quarter;
  final Color color;
  const SelectedQuarterModulesScreen(
      {super.key, required this.quarter, required this.color});

  @override
  ConsumerState<SelectedQuarterModulesScreen> createState() =>
      _SelectedQuarterModulesScreenState();
}

class _SelectedQuarterModulesScreenState
    extends ConsumerState<SelectedQuarterModulesScreen> {
  List<DocumentSnapshot> moduleDocs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        List<dynamic> assignedSections = userData[UserFields.assignedSections];
        List<DocumentSnapshot> teacherDocs =
            await getSectionTeacherDoc(assignedSections.first);
        String teacherID = teacherDocs.first.id;
        moduleDocs =
            await getAllAssignedQuarterModuleDocs(teacherID, widget.quarter);
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error getting selected quarter modules: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: stackedLoadingContainer(
        context,
        ref.read(loadingProvider).isLoading,
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.modulesBG), fit: BoxFit.cover)),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Gap(40),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 4), color: widget.color),
                  padding: EdgeInsets.all(10),
                  child: blackImpactBold('QUARTER ${widget.quarter.toString()}',
                      fontSize: 28)),
              vertical20Pix(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 500,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4), color: widget.color),
                      child: moduleDocs.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                  children: moduleDocs.map((module) {
                                final moduleData =
                                    module.data() as Map<dynamic, dynamic>;
                                String title = moduleData[ModuleFields.title];
                                return TextButton(
                                  onPressed: () =>
                                      NavigatorRoutes.selectedModule(context,
                                          moduleID: module.id),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 2)),
                                    padding: EdgeInsets.all(4),
                                    child: Row(children: [
                                      blackInterBold(title, fontSize: 20)
                                    ]),
                                  ),
                                );
                              }).toList()),
                            )
                          : Center(
                              child: blackImpactBold('No Modules Available',
                                  fontSize: 28))))
            ],
          ),
        ),
      ),
    );
  }
}
