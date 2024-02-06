import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonMethods {
  //#region Region - Route Right to Left
  static Route createRouteRTL(var screen) {
    return CupertinoPageRoute(builder: (_) => screen);
  }

  //#endregion


  // region to close keyboard
  static closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

// endregion

  // region read Json File
  static Future<Map<String, dynamic>> getJsonFile(String filePath) async {
    var jsonStr = await rootBundle.loadString(filePath);
    return json.decode(jsonStr);
  }

// endregion

  // region boundsFromLatLngList
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    var x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  // endregion

  // region open Url
  static Future<void> openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open the map.';
    }
  }

  // endregion

  // region getBytesFromAsset
  static Future<Uint8List?> getBytesFromAsset(String path, int size) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: size, targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    var img = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return img?.buffer.asUint8List();
  }

// endregion
}
