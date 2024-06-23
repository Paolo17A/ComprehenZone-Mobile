import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/string_util.dart';

class GradesScreen extends ConsumerStatefulWidget {
  const GradesScreen({super.key});

  @override
  ConsumerState<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends ConsumerState<GradesScreen> {
  List<DocumentSnapshot> quizResultDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        quizResultDocs = await getUserQuizResults();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting your quiz docs: $error')));
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
                    image: AssetImage(ImagePaths.gradesBG), fit: BoxFit.cover)),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(children: [
                Gap(40),
                blackImpactBold('GRADES', fontSize: 40),
                const Divider(color: Colors.black),
                studentGrades()
              ]),
            ),
          )),
    );
  }

  Widget studentGrades() {
    return vertical20Pix(
        child: Column(
            children: quizResultDocs.isNotEmpty
                ? quizResultDocs
                    .map((quizResult) => quizResultEntry(quizResult))
                    .toList()
                : [
                    vertical20Pix(
                        child: blackImpactBold(
                            'You have not yet answered any quizzes',
                            fontSize: 48))
                  ]));
  }

  Widget quizResultEntry(DocumentSnapshot quizResultDoc) {
    final quizResultData = quizResultDoc.data() as Map<dynamic, dynamic>;
    num grade = quizResultData[QuizResultFields.grade];
    String quizID = quizResultData[QuizResultFields.quizID];
    return FutureBuilder(
      future: getThisQuizDoc(quizID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.hasError) {
          return Text('Error viewing PDF');
        }
        final quizData = snapshot.data!.data() as Map<dynamic, dynamic>;
        String title = quizData[QuizFields.title];
        return vertical10Pix(
            child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(width: 2), color: CustomColors.grass),
          padding: EdgeInsets.all(10),
          child: TextButton(
            onPressed: () => NavigatorRoutes.selectedQuizResult(context,
                quizResultID: quizResultDoc.id, viewingGrades: true),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 2,
                    child: blackHelveticaBold(title,
                        fontSize: 16, overflow: TextOverflow.ellipsis)),
                Flexible(child: blackHelveticaBold('$grade/10', fontSize: 20))
              ],
            ),
          ),
        ));
      },
    );
  }
}
