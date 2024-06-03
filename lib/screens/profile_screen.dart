import 'package:comprehenzone_mobile/providers/profile_image_url_provider.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/loading_provider.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../utils/firebase_util.dart';
import '../utils/string_util.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String formattedName = '';
  String sectionName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);

        final userDoc = await getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';

        ref
            .read(profileImageURLProvider)
            .setImageURL(userData[UserFields.profileImageURL]);
        final section =
            await getThisSectionDoc(userData[UserFields.assignedSection]);
        final sectionData = section.data() as Map<dynamic, dynamic>;
        sectionName = sectionData[SectionFields.name];
        ref.read(loadingProvider.notifier).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting user profile: $error')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(profileImageURLProvider);
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(NavigatorRoutes.editProfile),
              icon: Icon(Icons.edit, color: Colors.black))
        ]),
        extendBodyBehindAppBar: true,
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImagePaths.profileBG),
                      fit: BoxFit.cover)),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Gap(40),
                      blackHelveticaBold('STUDENT PROFILE', fontSize: 36),
                      _profilePictureWidget(),
                      _nameAndSectionWidget(),
                      _birthDate(),
                      Gap(20),
                      _contactNumber(),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Image.asset(ImagePaths.profileID, scale: 4)])
                ],
              ),
            )));
  }

  Widget _profilePictureWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(width: 5)),
      padding: EdgeInsets.all(6),
      child: buildProfileImageWidget(
          profileImageURL: ref.read(profileImageURLProvider).profileImageURL,
          radius: 50),
    );
  }

  Widget _nameAndSectionWidget() {
    return vertical20Pix(
      child: Row(
        children: [
          Image.asset(ImagePaths.profileUser, scale: 10),
          Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              blackInterBold('NAME', fontSize: 16),
              blackInterRegular(formattedName, fontSize: 16),
              Gap(4),
              blackInterBold('SECTION', fontSize: 16),
              blackInterRegular(sectionName, fontSize: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _birthDate() {
    return Row(
      children: [
        Image.asset(ImagePaths.profileDateOfBirth, scale: 10),
        Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blackInterBold('DATE OF BIRTH', fontSize: 16),
            blackInterRegular('INSERT BIRTHDAY HERE', fontSize: 16),
          ],
        )
      ],
    );
  }

  Widget _contactNumber() {
    return Row(
      children: [
        Image.asset(ImagePaths.profileContactNumber, scale: 10),
        Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blackInterBold('CONTACT NUMBER', fontSize: 16),
            blackInterRegular('12345', fontSize: 16),
          ],
        )
      ],
    );
  }
}
