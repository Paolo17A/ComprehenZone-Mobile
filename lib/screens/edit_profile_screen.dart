import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_button_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/loading_provider.dart';
import '../providers/profile_image_url_provider.dart';
import '../widgets/custom_text_widgets.dart';
import '../utils/firebase_util.dart';
import '../utils/string_util.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? birthDate;
  final contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        ref.read(loadingProvider).toggleLoading(true);
        final userDoc = await getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        firstNameController.text = userData[UserFields.firstName];
        lastNameController.text = userData[UserFields.lastName];
        ref
            .read(profileImageURLProvider)
            .setImageURL(userData[UserFields.profileImageURL]);
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting user profile: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(profileImageURLProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.olympicBlue,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  blackHelveticaRegular('EDIT PROFILE', fontSize: 36),
                  _profilePictureWidget(),
                  regularTextField(
                      label: 'First Name',
                      textController: firstNameController,
                      textColor: Colors.black),
                  regularTextField(
                      label: 'Last Name',
                      textController: lastNameController,
                      textColor: Colors.black),
                  vertical20Pix(
                      child: saveChangesButton(
                          onPress: () => updateProfile(context, ref,
                              firstNameController: firstNameController,
                              lastNameController: lastNameController))),
                  Gap(100),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Image.asset(ImagePaths.profileID, scale: 4)])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profilePictureWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 5)),
          padding: EdgeInsets.all(6),
          child: buildProfileImageWidget(
              profileImageURL:
                  ref.read(profileImageURLProvider).profileImageURL,
              radius: 50),
        ),
        Gap(10),
        Column(
          children: [
            blueBorderElevatedButton(
                label: 'UPDATE PICTURE',
                height: 32,
                onPress: () => uploadProfilePicture(context, ref)),
            Gap(4),
            blueBorderElevatedButton(
                label: 'REMOVE PICTURE',
                height: 32,
                onPress: () => removeProfilePicture(context, ref))
          ],
        )
      ],
    );
  }
}
