import 'package:comprehenzone_mobile/screens/answer_quiz_screen.dart';
import 'package:comprehenzone_mobile/screens/edit_profile_screen.dart';
import 'package:comprehenzone_mobile/screens/grades_screen.dart';
import 'package:comprehenzone_mobile/screens/home_screen.dart';
import 'package:comprehenzone_mobile/screens/login_screen.dart';
import 'package:comprehenzone_mobile/screens/quarter_select_screen.dart';
import 'package:comprehenzone_mobile/screens/quiz_select_screen.dart';
import 'package:comprehenzone_mobile/screens/profile_screen.dart';
import 'package:comprehenzone_mobile/screens/selected_module_screen.dart';
import 'package:comprehenzone_mobile/screens/selected_quarter_modules_screen.dart';
import 'package:comprehenzone_mobile/screens/selected_quiz_result_screen.dart';
import 'package:flutter/material.dart';

class NavigatorRoutes {
  static const login = 'login';
  static const home = 'home';
  static const profile = 'profile';
  static const editProfile = 'editProfile';
  static const quarterSelect = 'quarterSelect';
  static void selectedQuarterModule(BuildContext context,
      {required int quarter, required Color color}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            SelectedQuarterModulesScreen(quarter: quarter, color: color)));
  }

  static void selectedModule(BuildContext context, {required String moduleID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SelectedModuleScreen(moduleID: moduleID)));
  }

  static const quizSelect = 'quizSelect';
  static void answerQuiz(BuildContext context, {required String quizID}) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AnswerQuizScreen(quizID: quizID)));
  }

  static void selectedQuizResult(BuildContext context,
      {required String quizResultID,
      bool isReplacing = false,
      bool viewingGrades = false}) {
    if (isReplacing) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => SelectedQuizResultScreen(
              quizResultID: quizResultID, viewingGrades: viewingGrades)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SelectedQuizResultScreen(
              quizResultID: quizResultID, viewingGrades: viewingGrades)));
    }
  }

  static const grades = 'grades';
}

final Map<String, WidgetBuilder> routes = {
  NavigatorRoutes.login: (context) => const LoginScreen(),
  NavigatorRoutes.home: (context) => const HomeScreen(),
  NavigatorRoutes.profile: (context) => const ProfileScreen(),
  NavigatorRoutes.editProfile: (context) => const EditProfileScreen(),
  NavigatorRoutes.quarterSelect: (context) => const QuarterSelectScreen(),
  NavigatorRoutes.quizSelect: (context) => const QuizSelectScreen(),
  NavigatorRoutes.grades: (context) => const GradesScreen()
};
