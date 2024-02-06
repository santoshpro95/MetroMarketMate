import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/shop_images/shop_images_screen.dart';
import 'package:mmm/features/shops/bloc/map_bloc.dart';
import 'package:mmm/features/shops/bloc/search_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/services/home_services.dart';
import 'package:mmm/utils/app_constants.dart';
import 'package:mmm/utils/common_methods.dart';

// region Shop Status
enum ShopStatus { Loading, Empty, Success, Failure }
// endregion

class ShopsBloc {
  // region Common Variables
  BuildContext context;
  List<Result> allShops = [];
  List<Result> searchedShop = [];

  // endregion

  // region Services
  HomeServices homeServices = HomeServices();

  // endregion

  // region Blocs
  late MapBloc mapBloc;
  SearchBloc searchBloc = SearchBloc();

  // endregion

  // region Controller
  final shopCtrl = StreamController<ShopStatus>.broadcast();
  final loadingCtrl = StreamController<bool>.broadcast();
  final citySelectionCtrl = ValueNotifier(AppConstants.cities.first);
  final toggleViewCtrl = ValueNotifier<bool>(false);

  // endregion

  // region | Constructor |
  ShopsBloc(this.context);

  // endregion

  // region Init
  void init() async {
    mapBloc = MapBloc(context);
    mapBloc.initMap();
    getShops();
  }

  // endregion

  // region onChangeCity
  void onChangeCity(String newValue) {
    citySelectionCtrl.value = newValue;
    getShops(isRefresh: true);
  }

  // endregion

  // region View Image btn
  void viewImageBtn(List<String> images) {
    var screen = ShopImagesScreen(images: images);
    var route = CommonMethods.createRouteRTL(screen);
    Navigator.push(context, route);
  }

  // endregion

  // region onChangeView
  void onChangeView(bool value) {
    toggleViewCtrl.value = !value;
    CommonMethods.closeKeyboard(context);
  }

  // endregion

  // region getShops
  Future<void> getShops({bool isRefresh = false}) async {
    try {
      // loading
      if (isRefresh) {
        if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
      }

      // get shops
      var response = await homeServices.getShops(citySelectionCtrl.value);

      // check result
      if (response.result == null) {
        if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Failure);
      }

      // get shops
      mapBloc.removeShopDetails(allShops);
      allShops.clear();
      searchedShop.clear();
      mapBloc.markers.clear();

      // add all shops
      allShops.addAll(response.result!);
      searchedShop.addAll(response.result!);

      // check empty shops
      if (allShops.isEmpty) {
        if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Empty);
        return;
      }

      // generate markers
      for (var shop in allShops) {
        var marker = mapBloc.getMarker(shop, false, allShops);
        mapBloc.markers.add(marker);
      }

      // refresh list and map
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Success);
      if (!mapBloc.mapCtrl.isClosed) mapBloc.mapCtrl.sink.add(true);

      // update camera
      if (!isRefresh) mapBloc.googleMapController = await mapBloc.controller.future;
      await mapBloc.googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(allShops.first.lat!, allShops.first.lng!), 15));
    } catch (exception) {
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Failure);
      print("get shop exception ==  $exception");
    } finally {
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    }
  }

  // endregion

  // region Dispose
  void dispose() {
    citySelectionCtrl.dispose();
    toggleViewCtrl.dispose();
    shopCtrl.close();
    mapBloc.dispose();
    loadingCtrl.close();
  }
// endregion
}
