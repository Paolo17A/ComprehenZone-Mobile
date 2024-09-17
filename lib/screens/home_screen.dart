import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_button_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(),
        drawer: _homeDrawer(context),
        extendBodyBehindAppBar: true,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: CustomColors.olympicBlue,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Gap(50),
                      homeButton(context,
                          color: CustomColors.grimGrey,
                          label: 'LEARNING MATERIALS',
                          imagePath: ImagePaths.homeBook,
                          onPress: () => Navigator.of(context)
                              .pushNamed(NavigatorRoutes.quarterSelect),
                          left: -30,
                          top: -5),
                      homeButton(context,
                          color: CustomColors.pastelOrange,
                          label: 'QUIZZES AND\nEXAM',
                          imagePath: ImagePaths.homeStudying,
                          onPress: () => Navigator.of(context)
                              .pushNamed(NavigatorRoutes.quizSelect),
                          right: -40,
                          bottom: -30),
                      homeButton(context,
                          color: CustomColors.pastelPink,
                          label: 'PRATICE ORAL FLUENCY',
                          imagePath: ImagePaths.homeFeedback,
                          onPress: () => Navigator.of(context)
                              .pushNamed(NavigatorRoutes.speechSelect),
                          left: -40,
                          bottom: -10),
                    ]),
                  ]),
            )),
      ),
    );
  }

  Widget _homeDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.navigatorBlue,
      child: Column(
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                color: CustomColors.grimGrey,
                child: Image.asset(ImagePaths.comprehenzoneLogo),
              )),
          Flexible(
              child: Column(
            children: [
              ListTile(
                  leading: Image.asset(ImagePaths.drawerHome, scale: 16),
                  title: blackInterRegular('HOME', textAlign: TextAlign.left),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Image.asset(ImagePaths.drawerProfile, scale: 16),
                  title:
                      blackInterRegular('PROFILE', textAlign: TextAlign.left),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(NavigatorRoutes.profile);
                  })
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              logOutButton(context),
            ],
          )
        ],
      ),
    );
  }
}
