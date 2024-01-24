import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/home/bloc/home_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/services/home_services.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/common_methods.dart';

// region Shop Status
enum ShopStatus { Loading, Empty, Success, Failure }
// endregion

class ShopsBloc {
  // region Common Variables
  BuildContext context;
  List<Result> shops = [];
  HomeBloc homeBloc;
  List<LatLng> allPoints = [];

  // endregion

  // region Google Map
  late Completer<GoogleMapController> controller = Completer();
  late GoogleMapController googleMapController;
  CameraPosition initialCameraPosition = const CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 7);
  Set<Marker> markers = HashSet<Marker>();
  late BitmapDescriptor markerIcon;
  // endregion

  // region Services
  HomeServices homeServices = HomeServices();

  // endregion

  // region Controller
  final shopCtrl = StreamController<ShopStatus>.broadcast();
  final mapCtrl = StreamController<bool>.broadcast();

  // endregion

  // region | Constructor |
  ShopsBloc(this.context, this.homeBloc);

  // endregion

  // region Init
  void init() {
    getShops();
    initMap();
  }

  // endregion

  // region initMap
  Future<void> initMap() async {
    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), AppImages.marker).then((value) => markerIcon = value);
    googleMapController = await controller.future;
    if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
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

      // generate markers
      for (var shop in shops) {
        var marker = getMarker(LatLng(shop.lat ?? 0, shop.lng ?? 0));
        markers.add(marker);
      }

      // refresh list and map
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Success);
      if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
    } catch (exception) {
      if (!shopCtrl.isClosed) shopCtrl.sink.add(ShopStatus.Failure);
      print(exception);
    }
  }

  // endregion

  // region GetMarker
  Marker getMarker(LatLng point) {
    return Marker(
      draggable: true,
      consumeTapEvents: true,
      visible: true,
      onTap: () {},
      anchor: const Offset(0.5, 0.5),
      markerId: MarkerId('$point'),
      icon: markerIcon,
      position: point,
    );
  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
