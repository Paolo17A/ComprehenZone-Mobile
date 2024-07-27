import 'package:comprehenzone_mobile/models/speech_model.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/string_util.dart';

class SpeechSelectScreen extends ConsumerStatefulWidget {
  const SpeechSelectScreen({super.key});

  @override
  ConsumerState<SpeechSelectScreen> createState() => _SpeechSelectScreenState();
}

class _SpeechSelectScreenState extends ConsumerState<SpeechSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagePaths.quizGB), fit: BoxFit.cover)),
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [Gap(40), _speechHeader(), _speechButtons()],
              )),
            ),
          )),
    );
  }

  Widget _speechHeader() {
    return vertical20Pix(
        child: blackImpactBold('PRACTICE YOUR SPEECH', fontSize: 32));
  }

  Widget _speechButtons() {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: speechCategories.length,
        itemBuilder: (context, index) {
          return vertical10Pix(
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.midnightBlue),
                  child: whiteImpactBold(speechCategories[index].category,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left)));
        });
  }
}
