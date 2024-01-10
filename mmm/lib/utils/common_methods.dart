import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonMethods{

  //#region Region - Route Right to Left
  static Route createRouteRTL(var screen) {
    return CupertinoPageRoute(builder: (_) => screen);
  }

  //#endregion

}