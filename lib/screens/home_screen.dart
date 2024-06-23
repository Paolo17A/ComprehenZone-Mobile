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
        drawer: Drawer(
          backgroundColor: CustomColors.pearlWhite,
          child: Column(
            children: [
              DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Container(color: CustomColors.paleCyan)),
              Flexible(
                  child: Column(
                children: [
                  ListTile(
                      leading: Image.asset(ImagePaths.drawerHome, scale: 16),
                      title: blackInterBold('HOME'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Image.asset(ImagePaths.drawerProfile, scale: 16),
                      title: blackInterBold('PROFILE'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(NavigatorRoutes.profile);
                      })
                ],
              )),
              logOutButton(context)
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagePaths.homeBG), fit: BoxFit.cover)),
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Gap(50),
                    homeButton(context,
                        color: CustomColors.paleCyan,
                        label: 'LEARNING MATERIALS',
                        imagePath: ImagePaths.homeBook,
                        onPress: () => Navigator.of(context)
                            .pushNamed(NavigatorRoutes.quarterSelect),
                        left: -30,
                        top: -5),
                    homeButton(context,
                        color: CustomColors.grass,
                        label: 'QUIZZES AND\nEXAM',
                        imagePath: ImagePaths.homeStudying,
                        onPress: () => Navigator.of(context)
                            .pushNamed(NavigatorRoutes.quizSelect),
                        right: -40,
                        bottom: -30),
                    homeButton(context,
                        color: CustomColors.limeGreen,
                        label: 'GRADES AND FEEDBACK',
                        imagePath: ImagePaths.homeFeedback,
                        onPress: () => Navigator.of(context)
                            .pushNamed(NavigatorRoutes.grades),
                        left: -40,
                        bottom: -10)
                  ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Image.asset(ImagePaths.research, scale: 3)])
                ])),
      ),
    );
  }
}
