import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonMethods{

  //#region Region - Route Right to Left
  static Route createRouteRTL(var screen) {
    return CupertinoPageRoute(builder: (_) => screen);
  }

  //#endregion

  // region read Json File
  static Future<Map<String, dynamic>> getJsonFile(String filePath) async {
    var jsonStr = await rootBundle.loadString(filePath);
    return json.decode(jsonStr);
  }

// endregion

}