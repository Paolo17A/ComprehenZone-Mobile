import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../models/speech_model.dart';
import '../utils/numbers_util.dart';

class SpeechResultScreen extends ConsumerStatefulWidget {
  final String speechResultID;
  final SpeechModel speechModel;
  const SpeechResultScreen(
      {super.key, required this.speechResultID, required this.speechModel});

  @override
  ConsumerState<SpeechResultScreen> createState() => _SpeechResultScreenState();
}

class _SpeechResultScreenState extends ConsumerState<SpeechResultScreen> {
  List<dynamic> sentenceResults = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final speechResultDoc =
            await getThisSpeechResult(widget.speechResultID);
        final speechResultData =
            speechResultDoc.data() as Map<dynamic, dynamic>;
        sentenceResults = speechResultData[SpeechResultFields.speechResults];
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting speech results: $error')));
        ref.read(loadingProvider).toggleLoading(false);
        navigator.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: whiteImpactBold(
            '${widget.speechModel.category.toUpperCase()} RESULTS'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all10Pix(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: CustomColors.midnightBlue, width: 4),
                        color: CustomColors.olympicBlue),
                    width: double.infinity,
                    child: Center(
                        child: whiteHelveticaBold(
                            'You got an average pronounciation accuracy of ${calculateAverageConfidence(sentenceResults).toStringAsFixed(2)}%',
                            fontSize: 20)),
                  ),
                  vertical10Pix(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: CustomColors.midnightBlue, width: 4),
                          color: CustomColors.olympicBlue),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sentenceResults.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    whiteHelveticaBold(
                                        '${index + 1}. ${widget.speechModel.sentences[index]}',
                                        fontSize: 20,
                                        textAlign: TextAlign.left),
                                    whiteHelveticaBold(
                                        'Confidence Level: ${(sentenceResults[index][SpeechFields.confidence] as double).toStringAsFixed(2)}%'),
                                    Gap(16),
                                    Container(
                                      width: double.infinity,
                                      //height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color:
                                                  CustomColors.backgroundBlue),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Wrap(
                                            children: (sentenceResults[index]
                                                        [SpeechFields.breakdown]
                                                    as List<dynamic>)
                                                .map((word) {
                                          final wordData =
                                              word as Map<String, dynamic>;
                                          return Text(
                                            '${wordData.keys.first} ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: wordData.values.first
                                                    ? Colors.green
                                                    : Colors.red),
                                          );
                                        }).toList()),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
