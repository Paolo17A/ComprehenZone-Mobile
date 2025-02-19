import 'dart:async';
import 'dart:math';
import 'package:comprehenzone_mobile/models/speech_model.dart';
import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_padding_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechSentenceScreen extends ConsumerStatefulWidget {
  final SpeechModel speechModel;
  final int speechIndex;
  const SpeechSentenceScreen(
      {super.key, required this.speechModel, required this.speechIndex});

  @override
  ConsumerState<SpeechSentenceScreen> createState() =>
      _SpeechSentenceScreenState();
}

class _SpeechSentenceScreenState extends ConsumerState<SpeechSentenceScreen>
    with TickerProviderStateMixin {
  //=================================================================================================
  //  Sentence VARIABLES
  int currentSentenceIndex = 0;
  List<Map<String, dynamic>> sentenceData = [];

  //  TEXT TO SPEECH VARIABLES
  late FlutterTts flutterTts;
  bool _hasDetectedVoice = false;

  //  SPEECH TO TEXT VARIABLES
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _doneListening = false;
  bool _wordsDetected = false;
  double _accuracy = 0;
  String _detectedSpeech = '';
  Map<String, HighlightedWord> correctWords = {};
  double accuracy = 0;
  double confidence = 0;
  List<Map<String, bool>> globalSentenceBreakdown = [];

//==============================================================================
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    setWordsToDetect();
    //setSentenceToSpeak();
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }
  //============================================================================

  //  Text to Speech Functions
  //============================================================================
  Future _playback(String text, double speed) async {
    await flutterTts
        .setLanguage('en-US'); // Set the language (adjust as needed)
    await flutterTts.setPitch(1.0); // Set pitch (adjust as needed)
    await flutterTts
        .setSpeechRate(speed / 2); // Set speech rate (adjust as needed)
    await flutterTts.speak(text);
  }
  //============================================================================

  //  Speech to Text Functions
  //============================================================================
  void setWordsToDetect() {
    List<String> words = widget.speechModel.sentences[currentSentenceIndex]
        .replaceAll('.', '')
        .toLowerCase()
        .split(' ');
    for (String word in words) {
      if (!correctWords.containsKey(word)) {
        correctWords[word] = HighlightedWord(
            textStyle: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 27));
      }
    }
  }

  void _listen() async {
    print('is listening: $_isListening');
    if (_isListening) {
      _stopListening();
      return;
    }
    final navigator = Navigator.of(context);
    //await _playback('i am listening', 1);
    _doneListening = false;
    _isListening = true;
    _hasDetectedVoice = false;
    bool available = await _speech.initialize(
        finalTimeout: Duration(seconds: 4),
        onStatus: (val) {
          print(val);
          if (val == 'done') {
            print('VOICE DETECTED: $_hasDetectedVoice');
            setState(() {
              _isListening = false;
              _speech.stop();
              _doneListening = true;
              if (!_hasDetectedVoice) {
                _wordsDetected = false;
                setSentenceToSpeak();
              }
              //bgmPlayer.resume();
            });
          }
        },
        onError: (val) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Error initializing microphone: ${val.toString()}')));
        });
    print('is available: $available');
    if (available) {
      setState(() {
        _doneListening = false;
        _isListening = true;
      });
      //await setSentenceToSpeak();
      print('BEFORE: ${sentenceData}');

      _speech.listen(
          listenFor: const Duration(seconds: 5),
          onResult: (val) {
            setState(() {
              _detectedSpeech = val.recognizedWords;

              if (val.hasConfidenceRating && val.confidence > 0) {
                _hasDetectedVoice = true;
                print('HAS CONFIDENCE');
                //  We must first determine if the app detected words from the mic
                int words = _getDetectedWords(val.recognizedWords);
                if (words > 1) {
                  print('found words');
                  _wordsDetected = true;
                } else {
                  _wordsDetected = false;
                  print('no words found');
                  setSentenceToSpeak();
                  return;
                }
                //  Calculate the accuracy
                _accuracy = _calculateSimilarity(
                    widget.speechModel.sentences[currentSentenceIndex]
                        .replaceAll('.', '')
                        .replaceAll(',', '')
                        .replaceAll('?', ''),
                    val.recognizedWords
                        .replaceAll('.', '')
                        .replaceAll(',', '')
                        .replaceAll('?', ''));
                _speech.stop();
                List<Map<String, bool>> sentenceBreakdown = [];
                List<String> allWordsInGivenSentence = widget
                    .speechModel.sentences[currentSentenceIndex]
                    .replaceAll('.', '')
                    .replaceAll('?', '')
                    .replaceAll(',', '')
                    .toLowerCase()
                    .split(' ');
                List<String> allWordsInRecitedSentence = val.recognizedWords
                    .replaceAll('.', '')
                    .replaceAll('?', '')
                    .replaceAll(',', '')
                    .toLowerCase()
                    .split(' ');

                //  Now let's scan for matches
                for (int i = 0; i < allWordsInGivenSentence.length; i++) {
                  if (i >= allWordsInRecitedSentence.length) {
                    sentenceBreakdown.add({allWordsInGivenSentence[i]: false});
                  } else {
                    if (allWordsInGivenSentence[i] ==
                        allWordsInRecitedSentence[i]) {
                      sentenceBreakdown.add({allWordsInGivenSentence[i]: true});
                    } else {
                      print('${allWordsInRecitedSentence[i]} did not match');
                      sentenceBreakdown
                          .add({allWordsInGivenSentence[i]: false});
                    }
                  }
                }

                print('sentence breakdown has been generated');
                accuracy = _accuracy;
                confidence = val.confidence;
                //  It is the first time to record this sentence
                if (sentenceData.length == currentSentenceIndex) {
                  print('first time recording');
                  sentenceData.add({
                    SpeechFields.breakdown: sentenceBreakdown,
                    SpeechFields.similarity:
                        double.parse(_accuracy.toStringAsFixed(2)),
                    SpeechFields.confidence:
                        double.parse(val.confidence.toStringAsFixed(2)) * 100,
                    SpeechFields.average: double.parse(
                        ((_accuracy + (val.confidence * 100)) / 2)
                            .toStringAsFixed(2)),
                  });
                }
                //  The user is trying to record again
                else {
                  print('recording again');
                  sentenceData[currentSentenceIndex] = {
                    SpeechFields.breakdown: sentenceBreakdown,
                    SpeechFields.similarity:
                        double.parse(_accuracy.toStringAsFixed(2)),
                    SpeechFields.confidence:
                        double.parse(val.confidence.toStringAsFixed(2)) * 100,
                    SpeechFields.average: double.parse(
                        ((_accuracy + (val.confidence * 100)) / 2)
                            .toStringAsFixed(2))
                  };
                }
                globalSentenceBreakdown = sentenceBreakdown;
                print('AFTER: ${sentenceData}');
                _isListening = false;
                _doneListening = true;
                setSentenceToSpeak();
              }
            });
          });
    }
    //  This is for handling initialization failure
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something happened')));

      _stopListening();
      navigator.pop();
    }
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
      _doneListening = false;
      _speech.stop();
    });
  }

  int _getDetectedWords(String sentence) {
    List<String> words = sentence.split(' ');
    return words.length;
  }

  double _calculateSimilarity(String sentence1, String sentence2) {
    if (sentence1.toLowerCase() == sentence2.toLowerCase()) {
      return 100;
    }

    List<String> words1 = sentence1.toLowerCase().split(' ');
    List<String> words2 = sentence2.toLowerCase().split(' ');

    int matchingWordPairs = 0;

    for (int i = 0; i < words1.length; i++) {
      for (int j = 0; j < words2.length; j++) {
        if (words1[i] == words2[j]) {
          matchingWordPairs++;
          words2[j] = ''; // Mark the word as used in sentence2
          break;
        }
      }
    }

    double similarity1 = matchingWordPairs / words1.length;
    double similarity2 = matchingWordPairs / words2.length;
    double finalSimilarity = min(similarity1, similarity2);

    double similarityPercentage = finalSimilarity * 100.0;

    return similarityPercentage;
  }
  //=================================================================================================

  //  Speech Quiz Functions
  //=================================================================================================
  void _goToNextSentence() {
    currentSentenceIndex++;
    if (currentSentenceIndex == widget.speechModel.sentences.length) {
      submitSpeechAnswers(context, ref,
          speechIndex: widget.speechIndex,
          sentenceData: sentenceData,
          speechModel: widget.speechModel);
    } else {
      _detectedSpeech = '';
      setWordsToDetect();
      setState(() {
        _isListening = false;
        _doneListening = false;
        _wordsDetected = false;
      });
      setSentenceToSpeak();
    }
  }

  //  AUDIO PLAYER
  //============================================================================
  Future setSentenceToSpeak() async {
    await flutterTts.pause();
    await flutterTts.stop();
    _isListening
        ? await _playback('I am listening...', 1)
        : _doneListening
            ? _wordsDetected
                ? await _playback(
                    'Done! Press the microphone button if you want to try again.',
                    1)
                : await _playback(
                    'We didn\'t hear anything. Please try again', 1)
            : await _playback(
                'Press the microphone button to record your voice.', 1);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return PopScope(
      onPopInvoked: (_) async {
        await flutterTts.pause();
        await flutterTts.stop();
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: CustomColors.dirtyPearl,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: blackHelveticaRegular(widget.speechModel.category)),
          ),
          floatingActionButton: ref.read(loadingProvider).isLoading
              ? null
              : _bottomFloatingButtons(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: switchedLoadingContainer(
            ref.read(loadingProvider).isLoading,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColors.olympicBlue),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _directions(),
                    _sentenceContainer(
                        widget.speechModel.sentences[currentSentenceIndex]),
                    CircleAvatar(
                      backgroundColor: CustomColors.dirtyPearl,
                      radius: 30,
                      child: IconButton(
                        onPressed: () {
                          flutterTts.speak(widget
                              .speechModel.sentences[currentSentenceIndex]);
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.volume_up),
                      ),
                    ),
                    if (_detectedSpeech.isNotEmpty && _doneListening)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: CustomColors.midnightBlue, width: 4)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  midnightBlueHelveticaBold(
                                      'Accuracy: ${(accuracy).toStringAsFixed(2)}%',
                                      fontSize: 17),
                                  all10Pix(
                                    child: midnightBlueHelveticaBold(
                                        'Confidence: ${(confidence * 100).toStringAsFixed(2)}%',
                                        fontSize: 17),
                                  ),
                                  if (globalSentenceBreakdown.isNotEmpty &&
                                      _wordsDetected)
                                    Wrap(
                                        children:
                                            globalSentenceBreakdown.map((word) {
                                      return Text('${word.keys.first} ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: word.values.first
                                                  ? Colors.green
                                                  : Colors.red));
                                    }).toList()),
                                ],
                              ),
                            ),
                          )),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _bottomFloatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_doneListening && _wordsDetected) Gap(70),
        FloatingActionButton.large(
          onPressed: () async {
            _listen();
          },
          backgroundColor: CustomColors.midnightBlue,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none,
              size: 50, color: Colors.white),
        ),
        if (_doneListening && _wordsDetected)
          SizedBox(
            width: 70,
            height: 70,
            child: IconButton(
                onPressed: _goToNextSentence,
                icon: Icon(Icons.fast_forward, size: 45)),
          ),
      ],
    );
  }

  Widget _directions() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: blackHelveticaBold(
            _isListening
                ? 'I am listening...'
                : _doneListening
                    ? _wordsDetected
                        ? 'Done! Press the microphone button if you want to try again.'
                        : 'We didn\'t hear anything. Please try again'
                    : 'Press the microphone button to record your voice.',
          )),
    );
  }

  Widget _sentenceContainer(String sentence) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
            color: CustomColors.dirtyPearl,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                all20Pix(
                    child: Center(
                        child: blackHelveticaBold(sentence, fontSize: 20))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
