import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_button_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/string_util.dart';

class QuarterSelectScreen extends StatelessWidget {
  const QuarterSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.modulesBG), fit: BoxFit.cover)),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Gap(40),
            blackImpactBold('MODULES', fontSize: 40),
            quarterButton(context,
                color: CustomColors.limeGreen,
                label: '1ST QUARTER',
                imagePath: ImagePaths.quarterEasyToUse,
                right: -40,
                top: -20,
                onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                    quarter: 1, color: CustomColors.limeGreen)),
            quarterButton(context,
                color: CustomColors.grass,
                label: '2ND QUARTER',
                imagePath: ImagePaths.quarterReading,
                top: -35,
                left: 100,
                onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                    quarter: 2, color: CustomColors.grass)),
            quarterButton(context,
                color: CustomColors.paleCyan,
                label: '3RD QUARTER',
                imagePath: ImagePaths.quarterIdea,
                left: -40,
                bottom: -20,
                onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                    quarter: 3, color: CustomColors.paleCyan)),
            quarterButton(context,
                color: const Color.fromARGB(255, 102, 211, 52),
                label: '4TH QUARTER',
                imagePath: ImagePaths.quarterBooks,
                right: -30,
                bottom: -20,
                onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                    quarter: 4,
                    color: const Color.fromARGB(255, 102, 211, 52))),
          ],
        ),
      ),
    );
  }
}
