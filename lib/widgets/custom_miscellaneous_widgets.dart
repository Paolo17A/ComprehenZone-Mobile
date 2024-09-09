import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/verification_image_provider.dart';
import '../utils/color_util.dart';
import '../utils/firebase_util.dart';
import 'custom_button_widgets.dart';
import 'custom_padding_widgets.dart';
import 'custom_text_field_widget.dart';
import 'custom_text_widgets.dart';

Widget stackedLoadingContainer(
    BuildContext context, bool isLoading, Widget child) {
  return Stack(children: [
    child,
    if (isLoading)
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5),
          child: const Center(child: CircularProgressIndicator()))
  ]);
}

Widget switchedLoadingContainer(bool isLoading, Widget child) {
  return isLoading ? const Center(child: CircularProgressIndicator()) : child;
}

Widget loginFieldsContainer(BuildContext context, WidgetRef ref,
    {required TextEditingController emailController,
    required TextEditingController passwordController}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      vertical20Pix(child: whiteInterRegular('WELCOME', fontSize: 28)),
      all10Pix(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            whiteInterBold('Email Address', fontSize: 18),
            CustomTextField(
                text: 'Email Address',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                displayPrefixIcon:
                    Icon(Icons.email, color: CustomColors.dirtyPearl)),
          ],
        ),
      ),
      all10Pix(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteInterBold('Password', fontSize: 18),
          CustomTextField(
              text: 'Password',
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              onSearchPress: () => logInUser(context, ref,
                  emailController: emailController,
                  passwordController: passwordController),
              displayPrefixIcon:
                  Icon(Icons.lock, color: CustomColors.dirtyPearl)),
        ],
      )),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {},
              child: whiteInterBold('Forgot Password?',
                  fontSize: 12, textDecoration: TextDecoration.underline))
        ],
      ),
      const Gap(30),
      loginButton(
          onPress: () => logInUser(context, ref,
              emailController: emailController,
              passwordController: passwordController)),
      /*Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        blackInterBold('Don\'t have an account?', fontSize: 12),
        TextButton(
            onPressed: () {
              ref.read(verificationImageProvider).resetVerificationImage();
              Navigator.of(context)
                  .pushReplacementNamed(NavigatorRoutes.register);
            },
            child: blackInterBold('REGISTER',
                fontSize: 12, textDecoration: TextDecoration.underline))
      ])*/
    ],
  );
}

Widget registerFieldsContainer(BuildContext context, WidgetRef ref,
    {required String userType,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController idNumberController}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(ImagePaths.frontPageLogo, scale: 10),
      blackInterBold('Register', fontSize: 40),
      emailAddressTextField(emailController: emailController),
      passwordTextField(
          label: 'Password', passwordController: passwordController),
      passwordTextField(
          label: 'Confirm Password',
          passwordController: confirmPasswordController),
      const Divider(color: Colors.black),
      regularTextField(
          label: 'First Name', textController: firstNameController),
      regularTextField(label: 'Last Name', textController: lastNameController),
      numberTextField(label: 'ID Number', textController: idNumberController),
      const Divider(color: Colors.black),
      verificationImageUploadWidget(context, ref),
      const Divider(color: Colors.black),
      registerButton(
          onPress: () => registerNewUser(context, ref,
              userType: userType,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              idNumberController: idNumberController)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        blackInterRegular('Already have an account?', fontSize: 12),
        TextButton(
            onPressed: () {
              ref.read(verificationImageProvider).resetVerificationImage();
              Navigator.of(context).pushReplacementNamed(NavigatorRoutes.login);
            },
            child: blackInterRegular('Login to your account',
                fontSize: 12, textDecoration: TextDecoration.underline))
      ])
    ],
  );
}

Widget emailAddressTextField({required TextEditingController emailController}) {
  return all10Pix(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        blackInterBold('Email Address', fontSize: 18),
        CustomTextField(
            text: 'Email Address',
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            displayPrefixIcon: const Icon(Icons.email))
      ],
    ),
  );
}

Widget passwordTextField(
    {required String label,
    required TextEditingController passwordController,
    Color? textColor}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      blackInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: passwordController,
          textInputType: TextInputType.visiblePassword,
          displayPrefixIcon:
              Icon(Icons.lock, color: textColor ?? CustomColors.dirtyPearl)),
    ],
  ));
}

Widget regularTextField(
    {required String label,
    required TextEditingController textController,
    Color? textColor}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      blackInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: textController,
          textInputType: TextInputType.name,
          textColor: textColor,
          displayPrefixIcon: null),
    ],
  ));
}

Widget numberTextField(
    {required String label,
    required TextEditingController textController,
    Color? textColor}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      blackInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: textController,
          textInputType: TextInputType.number,
          displayPrefixIcon: null),
    ],
  ));
}

Widget multiLineTextField(
    {required String label,
    required TextEditingController textController,
    Color? textColor}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      blackInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: textController,
          textInputType: TextInputType.multiline,
          displayPrefixIcon: null),
    ],
  ));
}

Widget verificationImageUploadWidget(
  BuildContext context,
  WidgetRef ref,
) {
  return Column(
    //crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [blackInterBold('Student ID', fontSize: 18)]),
      if (ref.read(verificationImageProvider).verificationImage != null)
        vertical10Pix(
          child: Container(
            decoration:
                BoxDecoration(color: Colors.black, border: Border.all()),
            child: Image.memory(
              ref.read(verificationImageProvider).verificationImage!,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: TextButton(
            onPressed: () =>
                ref.read(verificationImageProvider).setVerificationImage(),
            child: blackInterBold('SELECT STUDENT ID', fontSize: 12)),
      )
    ],
  );
}

Container viewContentContainer(BuildContext context, {required Widget child}) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: CustomColors.mediumSea,
        border: Border.all(color: Colors.black),
      ),
      child: child);
}

Widget viewContentLabelRow(BuildContext context,
    {required List<Widget> children}) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(children: children));
}

Widget viewContentEntryRow(BuildContext context,
    {required List<Widget> children}) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: Row(children: children));
}

Widget viewFlexTextCell(String text,
    {required int flex,
    backgroundColor = CustomColors.olympicBlue,
    Color textColor = Colors.black,
    Border customBorder =
        const Border.symmetric(horizontal: BorderSide(width: 3)),
    BorderRadius? customBorderRadius}) {
  return Flexible(
    flex: flex,
    child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: customBorder,
            borderRadius: customBorderRadius),
        child: ClipRRect(
          child: Center(
              child: SelectableText(text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ))),
        )),
  );
}

Widget viewFlexLabelTextCell(String text, int flex) {
  return viewFlexTextCell(text,
      flex: flex,
      backgroundColor: CustomColors.olympicBlue,
      textColor: Colors.black);
}

Widget viewFlexActionsCell(List<Widget> children,
    {required int flex,
    backgroundColor = CustomColors.olympicBlue,
    Color textColor = Colors.black,
    Border customBorder =
        const Border.symmetric(horizontal: BorderSide(width: 3)),
    BorderRadius? customBorderRadius}) {
  return Flexible(
      flex: flex,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: customBorder,
            borderRadius: customBorderRadius,
            color: backgroundColor),
        child: Center(
            child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.spaceEvenly,
                spacing: 10,
                runSpacing: 10,
                children: children)),
      ));
}

Widget viewContentUnavailable(BuildContext context, {required String text}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.65,
    child: Center(child: blackInterBold(text, fontSize: 44)),
  );
}

void showVerificationImageDialog(BuildContext context,
    {required String verificationImage}) {
  showDialog(
      context: context,
      builder: (_) => Dialog(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: blackInterBold('X'))
                        ]),
                  ),
                  vertical20Pix(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Image.network(
                        verificationImage,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}

Widget snapshotHandler(AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  } else if (!snapshot.hasData) {
    return const Text('No data found');
  } else if (snapshot.hasError) {
    return Text('Error gettin data: ${snapshot.error.toString()}');
  }
  return Container();
}

Widget buildProfileImageWidget(
    {required String profileImageURL, double radius = 40}) {
  return Column(children: [
    profileImageURL.isNotEmpty
        ? CircleAvatar(
            radius: radius, backgroundImage: NetworkImage(profileImageURL))
        : CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(ImagePaths.defaultProfilePic)),
  ]);
}
