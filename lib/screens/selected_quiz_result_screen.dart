import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/color_util.dart';
import '../widgets/custom_padding_widgets.dart';

class SelectedQuizResultScreen extends ConsumerStatefulWidget {
  final String quizResultID;
  final bool viewingGrades;
  const SelectedQuizResultScreen(
      {super.key, required this.quizResultID, required this.viewingGrades});

  @override
  ConsumerState<SelectedQuizResultScreen> createState() =>
      _SelectedQuizResultScreenState();
}

class _SelectedQuizResultScreenState
    extends ConsumerState<SelectedQuizResultScreen> {
  //  QUIZ RESULTS
  num grade = 0;
  List<dynamic> userAnswers = [];
  String quizTitle = '';
  List<dynamic> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        //  Get Quiz Result Data
        final quizResult = await FirebaseFirestore.instance
            .collection(Collections.quizResults)
            .doc(widget.quizResultID)
            .get();
        final quizResultData = quizResult.data() as Map<dynamic, dynamic>;
        grade = quizResultData[QuizResultFields.grade];
        userAnswers = quizResultData[QuizResultFields.answers];
        String quizID = quizResultData[QuizResultFields.quizID];

        //  Get Quiz Data
        final quiz = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizID)
            .get();
        final quizData = quiz.data() as Map<dynamic, dynamic>;
        quizTitle = quizData[QuizFields.title];
        final quizContent = quizData[QuizFields.questions];
        quizQuestions = jsonDecode(quizContent);

        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting this quiz result: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);

    return PopScope(
      onPopInvoked: (didPop) =>
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.viewingGrades) {
          return;
        }
        Navigator.of(context).pushReplacementNamed(NavigatorRoutes.quizSelect);
      }),
      child: Scaffold(
        appBar: AppBar(),
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _quizTitle(),
                    vertical10Pix(
                      child: Container(
                        decoration:
                            BoxDecoration(color: CustomColors.olympicBlue),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [_quizScore(), _questionsAndAnswers()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _quizTitle() {
    return Container(
        decoration: BoxDecoration(
            color: CustomColors.olympicBlue,
            border: Border.all(color: CustomColors.navigatorBlue)),
        padding: EdgeInsets.all(10),
        child:
            blackInterBold(quizTitle, fontSize: 20, textAlign: TextAlign.left));
  }

  Widget _quizScore() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: CustomColors.dirtyPearl,
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: ((MediaQuery.of(context).size.width * 0.9) / 10) * grade,
                decoration: BoxDecoration(
                    color: CustomColors.correctGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 0), spreadRadius: 1, blurRadius: 4)
                    ]),
              )),
          Center(
              child: blackInterBold(
                  'You got ${grade.toString()} out of ${quizQuestions.length.toString()} items correct.',
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _questionsAndAnswers() {
    return vertical20Pix(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 3),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: quizQuestions.length,
            itemBuilder: (context, index) {
              String formattedQuestion =
                  '${index + 1}. ${(quizQuestions[index][QuestionFields.question].toString())}';
              bool isCorrect = userAnswers[index].toString().toLowerCase() ==
                  quizQuestions[index][QuestionFields.answer]
                      .toString()
                      .toLowerCase();
              String yourAnswer =
                  'Your Answer: ${userAnswers[index]}) ${quizQuestions[index][QuestionFields.options][userAnswers[index]]}';
              String correctAnswer =
                  'Correct Answer: ${quizQuestions[index][QuestionFields.answer]}) ${quizQuestions[index][QuestionFields.options][quizQuestions[index][QuestionFields.answer]]}';

              return vertical10Pix(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      blackInterBold(formattedQuestion,
                          textAlign: TextAlign.left),
                      const Gap(7),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: isCorrect
                                ? CustomColors.correctGreen
                                : CustomColors.wrongRed,
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            interText(yourAnswer,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            if (!isCorrect)
                              interText(correctAnswer,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
