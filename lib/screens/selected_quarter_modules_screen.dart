import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/models/modules_model.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String gradeLevel = '';
  List<DocumentSnapshot> moduleDocs = [];
  //Map<dynamic, dynamic> moduleProgresses = {};
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        gradeLevel = userData[UserFields.gradeLevel];
        //  Handle module progresses
        /*if (!userData.containsKey(UserFields.moduleProgresses)) {
          Map<dynamic, dynamic> moduleProgresses = {};
          moduleProgresses['${ModuleProgressFields.quarter}${widget.quarter}'] =
              {};
          for (var module in Grade5Quarter1Modules) {
            moduleProgresses['${ModuleProgressFields.quarter}${widget.quarter}']
                [module.index.toString()] = {
              ModuleProgressFields.title: module.title,
              ModuleProgressFields.progress: 0
            };
          }
          await FirebaseFirestore.instance
              .collection(Collections.users)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({UserFields.moduleProgresses: moduleProgresses});
        }*/
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(40),
                _quarterHeader(),
                if (gradeLevel == '5' && widget.quarter == 1)
                  _quarterModulesStreamBuilder(Grade5Quarter1Modules)
                else if (gradeLevel == '5' && widget.quarter == 2)
                  _quarterModulesStreamBuilder(Grade5Quarter2Modules)
                else if (gradeLevel == '5' && widget.quarter == 3)
                  _quarterModulesStreamBuilder(Grade5Quarter3Modules)
                else if (gradeLevel == '5' && widget.quarter == 4)
                  _quarterModulesStreamBuilder(Grade5Quarter4Modules)
                else if (gradeLevel == '6' && widget.quarter == 1)
                  _quarterModulesStreamBuilder(Grade6Quarter1Modules)
                else if (gradeLevel == '6' && widget.quarter == 2)
                  _quarterModulesStreamBuilder(Grade6Quarter2Modules)
                else if (gradeLevel == '6' && widget.quarter == 3)
                  _quarterModulesStreamBuilder(Grade6Quarter3Modules)
                else if (gradeLevel == '6' && widget.quarter == 4)
                  _quarterModulesStreamBuilder(Grade6Quarter4Modules),
                _uploadedQuarters(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quarterHeader() {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 4), color: widget.color),
        padding: EdgeInsets.all(10),
        child: blackImpactBold('QUARTER ${widget.quarter.toString()}',
            fontSize: 28));
  }

  Widget _quarterModulesStreamBuilder(List<ModulesModel> quarterModules) {
    if (quarterModules.isEmpty) return Container();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.hasError) {
          return Text('Error viewing PDF');
        } else {
          final userData = snapshot.data!.data() as Map<dynamic, dynamic>;
          Map<dynamic, dynamic> moduleProgresses =
              userData[UserFields.moduleProgresses];
          Map<dynamic, dynamic> quarterMap = moduleProgresses[
              '${ModuleProgressFields.quarter}${widget.quarter}'];
          return _quarterModuleEntry(quarterMap, quarterModules);
        }
      },
    );
  }

  Widget _quarterModuleEntry(
      Map<dynamic, dynamic> quarterMap, List<ModulesModel> quarterModules) {
    return vertical20Pix(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            //height: 500,
            decoration: BoxDecoration(
                border: Border.all(width: 4), color: widget.color),
            child: Column(
                children: quarterModules.map((module) {
              String title = module.title;
              int index = module.index;

              bool hasStarted = quarterMap.containsKey(index.toString());
              num progress = hasStarted
                  ? quarterMap[index.toString()][ModuleProgressFields.progress]
                  : 0;
              return TextButton(
                  onPressed: index == 1 ||
                          hasStarted ||
                          (quarterMap.length == index - 1 &&
                              quarterMap[(index - 1).toString()]
                                      [ModuleProgressFields.progress] ==
                                  1)
                      ? () => NavigatorRoutes.viewModule(context,
                          quarter: widget.quarter.toString(),
                          index: index.toString(),
                          documentPath: module.documentPath)
                      : null,
                  child: Container(
                    //height: 50,
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    padding: EdgeInsets.all(4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          blackInterBold(title,
                              fontSize: 20, textAlign: TextAlign.left),
                          all10Pix(
                            child: blackInterRegular(
                                'Progress: ${(progress * 100).toStringAsFixed(2)}%'),
                          )
                        ]),
                  ));
            }).toList())));
  }

  Widget _uploadedQuarters() {
    return vertical10Pix(
        child: Column(
      children: [
        blackHelveticaBold('Uploaded Modules', fontSize: 20),
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            //height: 500,
            decoration: BoxDecoration(
                border: Border.all(width: 4), color: widget.color),
            child: moduleDocs.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                        children: moduleDocs.map((module) {
                      final moduleData = module.data() as Map<dynamic, dynamic>;
                      String title = moduleData[ModuleFields.title];
                      return TextButton(
                        onPressed: () => NavigatorRoutes.selectedModule(context,
                            moduleID: module.id),
                        child: Container(
                          height: 50,
                          decoration:
                              BoxDecoration(border: Border.all(width: 2)),
                          padding: EdgeInsets.all(4),
                          child: Row(
                              children: [blackInterBold(title, fontSize: 20)]),
                        ),
                      );
                    }).toList()),
                  )
                : Center(
                    child:
                        blackImpactBold('No Modules Available', fontSize: 28))),
      ],
    ));
  }
}
