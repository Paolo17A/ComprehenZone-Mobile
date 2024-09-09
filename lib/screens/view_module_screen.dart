import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/firebase_util.dart';
import '../utils/string_util.dart';

class ViewModuleScreen extends ConsumerStatefulWidget {
  final String quarter;
  final String index;
  final String documentPath;
  const ViewModuleScreen(
      {super.key,
      required this.quarter,
      required this.index,
      required this.documentPath});

  @override
  ConsumerState<ViewModuleScreen> createState() => _ViewModuleScreenState();
}

class _ViewModuleScreenState extends ConsumerState<ViewModuleScreen> {
  PageController _pageController = PageController();
  Map<dynamic, dynamic> moduleProgresses = {};
  num currentProgress = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        moduleProgresses = userData[UserFields.moduleProgresses];
        Map<dynamic, dynamic> quarterMap = moduleProgresses[
            '${ModuleProgressFields.quarter}${widget.quarter}'];
        if (quarterMap.containsKey(widget.index)) {
          currentProgress =
              quarterMap[widget.index][ModuleProgressFields.progress];
        } else {
          quarterMap[widget.index] = {ModuleProgressFields.progress: 0.0};
          moduleProgresses['${ModuleProgressFields.quarter}${widget.quarter}'] =
              quarterMap;
          await FirebaseFirestore.instance
              .collection(Collections.users)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({UserFields.moduleProgresses: moduleProgresses});
        }
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting current progress: $error')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: switchedLoadingContainer(
        ref.read(loadingProvider).isLoading,
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: PDFDocument.fromAsset(widget.documentPath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.hasError) {
                return Text('Error viewing PDF');
              }
              int pageCount = snapshot.data!.count;
              /*int currentPage =
                  min(currentProgress.toDouble().ceil(), pageCount);*/
              return PDFViewer(
                document: snapshot.data!,
                controller: _pageController,
                onPageChanged: (currentPage) {
                  num newCurrentProgress = (currentPage + 1) / pageCount;
                  print('Current progress: $newCurrentProgress');
                  if (newCurrentProgress > currentProgress) {
                    moduleProgresses[
                            '${ModuleProgressFields.quarter}${widget.quarter}'][
                        widget
                            .index][ModuleProgressFields
                        .progress] = newCurrentProgress;
                    FirebaseFirestore.instance
                        .collection(Collections.users)
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(
                            {UserFields.moduleProgresses: moduleProgresses});
                    currentProgress = newCurrentProgress;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
