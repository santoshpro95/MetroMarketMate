import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/services/home_services.dart';

// region Shop Status
enum ShopStatus { Loading, Empty, Success, Failure }
// endregion

class ShopsBloc {
  // region Common Variables
  BuildContext context;
  List<Result> shops = [];

  // endregion

  // region Services
  HomeServices homeServices = HomeServices();

  // endregion

  // region Controller
  final shopCtrl = StreamController<ShopStatus>.broadcast();

  // endregion

  // region | Constructor |
  ShopsBloc(this.context);

  // endregion

  // region Init
  void init() {
    getShops();
  }

  // endregion

  // region getShops
  Future<void> getShops() async {
    try {
      // get shops
      var response = await homeServices.getShops();

      // check result
      if (response.result == null) {
        if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Failure);
      }

      // get shops
      shops.clear();
      shops.addAll(response.result!);

      // check empty shops
      if (shops.isEmpty) {
        if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Empty);
      }

      // set status
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Success);
    } catch (exception) {
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Failure);
      print(exception);
    }
  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
