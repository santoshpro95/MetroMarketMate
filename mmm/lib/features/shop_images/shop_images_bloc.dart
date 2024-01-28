import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:mmm/features/shop_images/phone_number_popup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopImagesBloc {
  // region Common Variables
  BuildContext context;
  List<String> images;
  List<String> phoneNumber = [];
  final PageController pageController = PageController();
  int activePage = 0;

  // endregion

  // region Controller
  final shopImageCtrl = StreamController<int>.broadcast();
  final phoneCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  ShopImagesBloc(this.context, this.images);

  // endregion

  // region Init
  void init() {
    loadPhone();
  }

  // endregion

  // region loadPhone
  Future<void> loadPhone() async {
    try {
      phoneNumber.clear();
      for (var image in images) {
        File imageFile = await urlToFile(image);
        var text = await getImageToText(imageFile);
        List<String> numbers = extractNumbers(text);
        phoneNumber.addAll(numbers);
      }
    } catch (exception) {
      print(exception);
    } finally {
      if (!phoneCtrl.isClosed) phoneCtrl.sink.add(false);
    }
  }

  // endregion

  // region shopPhonePopup
  void shopPhonePopup() {
    showModalBottomSheet(context: context, builder: (context) => phoneNumberPopup(this));
  }

  // endregion

  // region phoneCall
  void phoneCall(String phone) async {
    try {
      final call = Uri.parse('tel:+91 $phone');
      if (await canLaunchUrl(call)) {
        launchUrl(call);
      } else {
        throw 'Could not launch $call';
      }
    } catch (exception) {
      print(exception);
    }
  }

  // endregion

  // region whatsapp
  void whatsapp(String phone) async {
    var androidUrl = "whatsapp://send?phone=$phone&text=Hi, I need order";
    var iosUrl = "https://wa.me/$phone?text=${Uri.parse('Hi, I need order')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } catch (exception) {
      print(exception);
    }
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

  // region  extractNumbers
  List<String> extractNumbers(String input) {
    RegExp regExp = RegExp(r'\b\d{10}\b');
    Iterable<RegExpMatch> matches = regExp.allMatches(input);
    List<String> numbers = matches.map((match) => match.group(0)!).toList();
    return numbers;
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
