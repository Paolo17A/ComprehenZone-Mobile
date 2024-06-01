import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VerificationImageNotifier extends ChangeNotifier {
  Uint8List? verificationImage;

  Future setVerificationImage() async {
    ImagePicker imagePicker = ImagePicker();

    final selectedXFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedXFile == null) {
      return;
    }
    verificationImage = await selectedXFile.readAsBytes();
    notifyListeners();
  }

  void resetVerificationImage() {
    verificationImage = null;
    notifyListeners();
  }
}

final verificationImageProvider =
    ChangeNotifierProvider<VerificationImageNotifier>(
        (ref) => VerificationImageNotifier());
