import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_button_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
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
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: CustomColors.olympicBlue,
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Gap(40),
              vertical10Pix(
                child: Container(
                    decoration: BoxDecoration(
                        color: CustomColors.indigo,
                        border: Border.all(color: Colors.white, width: 4)),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    child:
                        blackHelveticaBold('LEARNING MATERIALS', fontSize: 20)),
              ),
              quarterButton(context,
                  color: CustomColors.getQuarterColor('1'),
                  label: '1ST QUARTER',
                  imagePath: ImagePaths.quarterEasyToUse,
                  right: -40,
                  top: -20,
                  onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                      quarter: 1, color: CustomColors.getQuarterColor('1'))),
              quarterButton(context,
                  color: CustomColors.getQuarterColor('2'),
                  label: '2ND QUARTER',
                  imagePath: ImagePaths.quarterReading,
                  top: -35,
                  left: 100,
                  onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                      quarter: 2, color: CustomColors.getQuarterColor('2'))),
              quarterButton(context,
                  color: CustomColors.getQuarterColor('3'),
                  label: '3RD QUARTER',
                  imagePath: ImagePaths.quarterIdea,
                  left: -40,
                  bottom: -20,
                  onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                      quarter: 3, color: CustomColors.getQuarterColor('3'))),
              quarterButton(context,
                  color: CustomColors.getQuarterColor('4'),
                  label: '4TH QUARTER',
                  imagePath: ImagePaths.quarterBooks,
                  right: -30,
                  bottom: -20,
                  onPress: () => NavigatorRoutes.selectedQuarterModule(context,
                      quarter: 4, color: CustomColors.getQuarterColor('4'))),
            ],
          ),
        ),
      ),
    );
  }
}
