import 'dart:async';

import 'package:flutter/material.dart';

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

  // region onPageChange
  void onPageChange(int index){
    if(!shopImageCtrl.isClosed) shopImageCtrl.sink.add(index);
  }
  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
