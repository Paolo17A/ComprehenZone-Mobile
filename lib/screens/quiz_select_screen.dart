import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/loading_provider.dart';
import '../utils/firebase_util.dart';
import '../utils/string_util.dart';

class QuizSelectScreen extends ConsumerStatefulWidget {
  const QuizSelectScreen({super.key});

  @override
  ConsumerState<QuizSelectScreen> createState() => _QuizSelectScreenState();
}

class _QuizSelectScreenState extends ConsumerState<QuizSelectScreen> {
  List<DocumentSnapshot> quizDocs = [];
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
        print(teacherID);
        quizDocs = await getAllAssignedQuizDocs(teacherID);
        print('QUIZZES FOUND: ${quizDocs.length}');
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
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: CustomColors.olympicBlue,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Gap(40),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          color: CustomColors.grass),
                      padding: EdgeInsets.all(10),
                      child: blackHelveticaBold('QUIZZES AND EXAMS',
                          fontSize: 28)),
                  vertical20Pix(
                      child: Column(
                          children: quizDocs
                              .map((quiz) => quizEntryFutureBuilder(quiz))
                              .toList()))
                ],
              ),
            )),
      ),
    );
  }

  Widget quizEntryFutureBuilder(DocumentSnapshot quizDoc) {
    final quizData = quizDoc.data() as Map<dynamic, dynamic>;
    String title = quizData[QuizFields.title];
    return FutureBuilder(
      future: getQuizResult(quizDoc.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return blackInterRegular('Error getting quiz status');
        } else if (!snapshot.hasData) {
          return _quizEntryWidget(
              quizID: quizDoc.id, title: title, isDone: false);
        }
        final quizResult = snapshot.data!.id;
        return _quizEntryWidget(
            quizID: quizDoc.id,
            title: title,
            isDone: true,
            quizResultID: quizResult);
      },
    );
  }

  Widget _quizEntryWidget(
      {required String quizID,
      required String title,
      required bool isDone,
      String quizResultID = ''}) {
    return vertical10Pix(
      child: TextButton(
        onPressed: () {
          if (isDone) {
            print('VIEW RESULTS');
            NavigatorRoutes.selectedQuizResult(context,
                quizResultID: quizResultID);
          } else {
            print('WILL ANSWER PALANG');
            NavigatorRoutes.answerQuiz(context, quizID: quizID);
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.white),
                color: CustomColors.grass),
            padding: EdgeInsets.all(10),
            child: Center(
                child: blackInterBold(title,
                    fontSize: 20,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis))),
      ),
    );
  }
}
