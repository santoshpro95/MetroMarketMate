import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ShopImagesBloc {
  // region Common Variables
  BuildContext context;
  List<String> images;
  final PageController pageController = PageController();
  int activePage = 0;

  // endregion

  // region Controller
  final shopImageCtrl = StreamController<int>.broadcast();

  // endregion

  // region | Constructor |
  ShopImagesBloc(this.context, this.images);

  // endregion

  // region Init
  void init() {}

  // endregion

  // region callRestaurant
  Future<void> callRestaurant() async {
    File imageFile = await urlToFile(images.first);
    var text = await getImageToText(imageFile);
    print(text);
  }

  // endregion

  // region urlToFile
  Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  // endregion

  // region getImageToText
  Future<String> getImageToText(File image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFile(image));
    String text = recognizedText.text.toString();
    return text;
  }

  // endregion

  // region onPageChange
  void onPageChange(int index) {
    if (!shopImageCtrl.isClosed) shopImageCtrl.sink.add(index);
  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
