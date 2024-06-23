//==============================================================================
//USERS=========================================================================
//==============================================================================
// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprehenzone_mobile/providers/profile_image_url_provider.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/loading_provider.dart';
import '../providers/user_type_provider.dart';
import '../providers/verification_image_provider.dart';
import 'string_util.dart';

bool hasLoggedInUser() {
  return FirebaseAuth.instance.currentUser != null;
}

Future logInUser(BuildContext context, WidgetRef ref,
    {required TextEditingController emailController,
    required TextEditingController passwordController}) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  try {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please fill up all given fields.')));
      return;
    }
    ref.read(loadingProvider).toggleLoading(true);
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    final userDoc = await getCurrentUserDoc();
    final userData = userDoc.data() as Map<dynamic, dynamic>;

    if (userData[UserFields.userType] != UserTypes.student) {
      await FirebaseAuth.instance.signOut();
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('This mobile app is for students only.')));
      ref.read(loadingProvider.notifier).toggleLoading(false);
      return;
    }

    //  reset the password in firebase in case client reset it using an email link.
    if (userData[UserFields.password] != passwordController.text) {
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({UserFields.password: passwordController.text});
    }
    ref.read(userTypeProvider).setUserType(userData[UserFields.userType]);
    ref.read(loadingProvider.notifier).toggleLoading(false);
    emailController.clear();
    passwordController.clear();

    navigator.pushNamed(NavigatorRoutes.home);
  } catch (error) {
    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text('Error logging in: $error')));
    ref.read(loadingProvider.notifier).toggleLoading(false);
  }
}

Future registerNewUser(BuildContext context, WidgetRef ref,
    {required String userType,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController idNumberController}) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  try {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        idNumberController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please fill up all given fields.')));
      return;
    }
    if (!emailController.text.contains('@') ||
        !emailController.text.contains('.com')) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please input a valid email address')));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('The passwords do not match')));
      return;
    }
    if (passwordController.text.length < 6) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('The password must be at least six characters long')));
      return;
    }
    if (ref.read(verificationImageProvider).verificationImage == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Please upload an image of your student ID.')));
      return;
    }
    //  Create user with Firebase Auth
    ref.read(loadingProvider).toggleLoading(true);
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text);

    //  Create new document is Firestore database
    await FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      UserFields.email: emailController.text.trim(),
      UserFields.password: passwordController.text,
      UserFields.firstName: firstNameController.text.trim(),
      UserFields.lastName: lastNameController.text.trim(),
      UserFields.userType: userType,
      UserFields.profileImageURL: '',
      UserFields.idNumber: idNumberController.text.trim(),
      UserFields.isVerified: false,
      UserFields.assignedSections: []
    });

    final storageRef = FirebaseStorage.instance
        .ref()
        .child(StorageFields.verificationImages)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('${FirebaseAuth.instance.currentUser!.uid}.png');
    final uploadTask = storageRef
        .putData(ref.read(verificationImageProvider).verificationImage!);
    final taskSnapshot = await uploadTask;
    final String verificationImage = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({UserFields.verificationImage: verificationImage});
    scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Successfully registered new user')));
    await FirebaseAuth.instance.signOut();
    ref.read(loadingProvider).toggleLoading(false);
    ref.read(verificationImageProvider).resetVerificationImage();
    navigator.pushReplacementNamed(NavigatorRoutes.login);
  } catch (error) {
    scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error registering new user: $error')));
    ref.read(loadingProvider.notifier).toggleLoading(false);
  }
}

Future<DocumentSnapshot> getCurrentUserDoc() async {
  return await getThisUserDoc(FirebaseAuth.instance.currentUser!.uid);
}

Future<DocumentSnapshot> getThisUserDoc(String userID) async {
  return await FirebaseFirestore.instance
      .collection(Collections.users)
      .doc(userID)
      .get();
}

Future<String> getCurrentUserType() async {
  final userDoc = await getCurrentUserDoc();
  final userData = userDoc.data() as Map<dynamic, dynamic>;
  return userData[UserFields.userType];
}

Future<List<DocumentSnapshot>> getAllTeacherDocs() async {
  final users = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.teacher)
      .get();
  return users.docs.map((user) => user as DocumentSnapshot).toList();
}

Future<List<DocumentSnapshot>> getAllStudentDocs() async {
  final users = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.student)
      .get();
  return users.docs.map((user) => user as DocumentSnapshot).toList();
}

Future<List<DocumentSnapshot>> getSectionStudentDocs(String sectionID) async {
  final students = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.student)
      .where(UserFields.assignedSections, arrayContains: sectionID)
      .get();
  return students.docs.map((student) => student as DocumentSnapshot).toList();
}

Future<List<DocumentSnapshot>> getSectionTeacherDoc(String sectionID) async {
  final teachers = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.teacher)
      .where(UserFields.assignedSections, arrayContains: sectionID)
      .get();
  return teachers.docs.map((teacher) => teacher as DocumentSnapshot).toList();
}

Future<List<DocumentSnapshot>> getStudentsWithNoSectionDocs() async {
  final students = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.student)
      .where(UserFields.assignedSections, isEqualTo: [])
      .where(UserFields.isVerified, isEqualTo: true)
      .get();
  return students.docs.map((student) => student as DocumentSnapshot).toList();
}

Future<List<DocumentSnapshot>> getAvailableTeacherDocs(String sectionID) async {
  final teachers = await FirebaseFirestore.instance
      .collection(Collections.users)
      .where(UserFields.userType, isEqualTo: UserTypes.teacher)
      .get();

  final availableTeachers = teachers.docs.where((doc) {
    List assignedSections = doc[UserFields.assignedSections];
    return !assignedSections.contains(sectionID);
  }).toList();

  return availableTeachers;
}

Future uploadProfilePicture(BuildContext context, WidgetRef ref) async {
  try {
    ImagePicker imagePicker = ImagePicker();
    final selectedXFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedXFile == null) {
      return;
    }
    //  Upload proof of employment to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(StorageFields.profilePics)
        .child('${FirebaseAuth.instance.currentUser!.uid}.png');
    final uploadTask = storageRef.putFile(File(selectedXFile.path));
    final taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({UserFields.profileImageURL: downloadURL});
    ref.read(profileImageURLProvider).setImageURL(downloadURL);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully uploaded new profile picture.')));
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading new profile picture: $error')));
    ref.read(loadingProvider).toggleLoading(false);
  }
}

Future removeProfilePicture(BuildContext context, WidgetRef ref) async {
  try {
    //  Remove profile pic from cloud storage
    ref.read(loadingProvider).toggleLoading(true);
    await FirebaseStorage.instance
        .ref()
        .child(StorageFields.profilePics)
        .child('${FirebaseAuth.instance.currentUser!.uid}.png')
        .delete();

    //Set profileImageURL paramter to ''
    await FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({UserFields.profileImageURL: ''});
    ref.read(profileImageURLProvider).setImageURL('');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully removed profile picture.')));
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading new profile picture: $error')));
    ref.read(loadingProvider).toggleLoading(false);
  }
}

Future updateProfile(BuildContext context, WidgetRef ref,
    {required TextEditingController firstNameController,
    required TextEditingController lastNameController}) async {
  if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill up all given fields.')));
    return;
  }
  try {
    ref.read(loadingProvider).toggleLoading(true);
    FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      UserFields.firstName: firstNameController.text.trim(),
      UserFields.lastName: lastNameController.text.trim(),
    });
    ref.read(loadingProvider).toggleLoading(false);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(NavigatorRoutes.profile);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${error.toString()}')));
    ref.read(loadingProvider).toggleLoading(false);
  }
}

//==============================================================================
//SECTIONS======================================================================
//==============================================================================
Future<DocumentSnapshot> getThisSectionDoc(String sectionID) async {
  return await FirebaseFirestore.instance
      .collection(Collections.sections)
      .doc(sectionID)
      .get();
}

//==============================================================================
//MODULES-======================================================================
//==============================================================================
Future<DocumentSnapshot> getThisModuleDoc(String moduleID) async {
  return await FirebaseFirestore.instance
      .collection(Collections.modules)
      .doc(moduleID)
      .get();
}

Future<List<DocumentSnapshot>> getAllAssignedQuarterModuleDocs(
    String teacherID, int quarter) async {
  final modules = await FirebaseFirestore.instance
      .collection(Collections.modules)
      .where(ModuleFields.teacherID, isEqualTo: teacherID)
      .where(ModuleFields.quarter, isEqualTo: quarter)
      .get();
  return modules.docs.map((e) => e as DocumentSnapshot).toList();
}

//==============================================================================
//QUIZZES=======================================================================
//==============================================================================
Future<DocumentSnapshot> getThisQuizDoc(String quizID) async {
  return await FirebaseFirestore.instance
      .collection(Collections.quizzes)
      .doc(quizID)
      .get();
}

Future<List<DocumentSnapshot>> getAllAssignedQuizDocs(String teacherID) async {
  final sectionQuizzes = await FirebaseFirestore.instance
      .collection(Collections.quizzes)
      .where(QuizFields.teacherID, isEqualTo: teacherID)
      .get();
  final globalQuizzes = await FirebaseFirestore.instance
      .collection(Collections.quizzes)
      .where(QuizFields.isGlobal, isEqualTo: true)
      .get();
  return [...sectionQuizzes.docs, ...globalQuizzes.docs]
      .map((e) => e as DocumentSnapshot)
      .toList();
}

Future<DocumentSnapshot?> getQuizResult(String quizID) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection(Collections.quizResults)
      .where(QuizResultFields.quizID, isEqualTo: quizID)
      .where(QuizResultFields.studentID,
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .limit(1)
      .get();

  if (result.docs.isNotEmpty) {
    return result.docs.first;
  } else {
    return null;
  }
}

void submitQuizAnswers(BuildContext context, WidgetRef ref,
    {required String quizID,
    required List<dynamic> selectedAnswers,
    required int correctAnswers}) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  //final navigator = Navigator.of(context);
  try {
    ref.read(loadingProvider).toggleLoading(true);

    final quizResultReference = await FirebaseFirestore.instance
        .collection(Collections.quizResults)
        .add({
      QuizResultFields.studentID: FirebaseAuth.instance.currentUser!.uid,
      QuizResultFields.quizID: quizID,
      QuizResultFields.answers: selectedAnswers,
      QuizResultFields.grade: correctAnswers,
    });

    scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Successfully submitted this quiz.')));
    ref.read(loadingProvider).toggleLoading(false);

    NavigatorRoutes.selectedQuizResult(context,
        quizResultID: quizResultReference.id, isReplacing: true);
    // navigator.pop();
    // navigator.pushReplacementNamed(NavigatorRoutes.studentSubmittables);
  } catch (error) {
    scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error submitting quiz answers: $error')));
    ref.read(loadingProvider).toggleLoading(false);
  }
}

//==============================================================================
//QUIZ RESULTS==================================================================
//==============================================================================

Future<List<DocumentSnapshot>> getUserQuizResults() async {
  final quizResults = await FirebaseFirestore.instance
      .collection(Collections.quizResults)
      .where(QuizResultFields.studentID,
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  return quizResults.docs.map((e) => e as DocumentSnapshot).toList();
}
