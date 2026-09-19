import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {

  Future<String> readText(File imageFile) async {

    final inputImage = InputImage.fromFile(imageFile);

    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    return recognizedText.text;
  }
}