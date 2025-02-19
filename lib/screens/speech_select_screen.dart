import 'package:comprehenzone_mobile/models/speech_model.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/navigator_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/string_util.dart';

class SpeechSelectScreen extends ConsumerStatefulWidget {
  const SpeechSelectScreen({super.key});

  @override
  ConsumerState<SpeechSelectScreen> createState() => _SpeechSelectScreenState();
}

class _SpeechSelectScreenState extends ConsumerState<SpeechSelectScreen> {
  int currentSpeechIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final userDoc = await getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        currentSpeechIndex = userData[UserFields.speechIndex];
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ref.read(loadingProvider).toggleLoading(false);
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error getting current speech index: $error')));
      }
    });
  }

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
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: CustomColors.olympicBlue,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [_speechHeader(), _speechButtons()],
                ),
              ),
            ),
          )),
    );
  }

  Widget _speechHeader() {
    return vertical20Pix(
        child: blackHelveticaBold('PRACTICE YOUR SPEECH', fontSize: 32));
  }

  Widget _speechButtons() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: speechCategories.length,
        itemBuilder: (context, index) {
          return vertical10Pix(
              child: ElevatedButton(
                  onPressed: () async {
                    if (currentSpeechIndex == index + 1) {
                      NavigatorRoutes.speechSentence(context,
                          speechIndex: index + 1,
                          speechModel: speechCategories[index]);
                    } else if (currentSpeechIndex > index + 1) {
                      NavigatorRoutes.selectedSpeechResult(context,
                          speechResultID:
                              await getThisSpeechResultIDByIndex(index + 1),
                          speechModel: speechCategories[index]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.dirtyPearl),
                  child: blackHelveticaBold(speechCategories[index].category,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left)));
        });
  }
}
