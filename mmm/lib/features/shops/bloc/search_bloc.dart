import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';

class SearchBloc {
  // region Controller
  final searchTextCtrl = TextEditingController();
  final searchCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  SearchBloc();

  // endregion

  // region onSearch
  void onSearch(String text, ShopsBloc shopsBloc) {
    if (shopsBloc.allShops.isEmpty) return;
    shopsBloc.searchedShop.clear();

    // check search text
    var isEmpty = text.isEmpty;
    if (!searchCtrl.isClosed) searchCtrl.sink.add(isEmpty);

    // filter shop
    for (var shop in shopsBloc.allShops) {
      if (shop.name!.toLowerCase().contains(text.toLowerCase())) {
        shopsBloc.searchedShop.add(shop);
      }
    }

    // refresh
    if (shopsBloc.searchedShop.isEmpty) {
      if (!shopsBloc.shopCtrl.isClosed) shopsBloc.shopCtrl.sink.add(ShopStatus.Empty);
    } else {
      if (!shopsBloc.shopCtrl.isClosed) shopsBloc.shopCtrl.sink.add(ShopStatus.Success);
    }

    // refresh map markers
    shopsBloc.mapBloc.removeShopDetails(shopsBloc.searchedShop);
  }

// endregion

// region clear Search
  void clearSearch(ShopsBloc shopsBloc) {
    searchTextCtrl.clear();
    onSearch("", shopsBloc);
  }
// endregion
}
