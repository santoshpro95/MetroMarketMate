import 'dart:async';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map;
import 'package:mmm/features/home/home_bloc.dart';
import 'package:mmm/features/shop_images/shop_images_screen.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/services/home_services.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/common_methods.dart';
import '../ui/open_map_popup.dart';

// region Shop Status
enum ShopStatus { Loading, Empty, Success, Failure }
// endregion

class ShopsBloc {
  // region Common Variables
  BuildContext context;
  List<Result> shops = [];
  HomeBloc homeBloc;
  List<LatLng> allPoints = [];
  PageController pageController = PageController();

  // endregion

  // region Google Map
  late Completer<GoogleMapController> controller = Completer();
  late GoogleMapController googleMapController;
  CameraPosition initialCameraPosition = const CameraPosition(target: LatLng(28.490147, 77.094030), zoom: 15);
  Set<Marker> markers = HashSet<Marker>();
  late BitmapDescriptor markerIcon;
  late BitmapDescriptor selectedMarkerIcon;

  // endregion

  // region Services
  HomeServices homeServices = HomeServices();

  // endregion

  // region Controller
  final shopCtrl = StreamController<ShopStatus>.broadcast();
  final mapCtrl = StreamController<bool>.broadcast();
  final showShopCtrl = ValueNotifier(Result());

  // endregion

  // region | Constructor |
  ShopsBloc(this.context, this.homeBloc);

  // endregion

  // region Init
  void init() {
    initMap();
    getShops();
  }

  // endregion

  // region initMap
  Future<void> initMap() async {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), AppImages.marker).then((value) => markerIcon = value);
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), AppImages.selectedMarker).then((value) => selectedMarkerIcon = value);
    googleMapController = await controller.future;
  }

  // endregion

  // region View Image btn
  void viewImageBtn(List<String> images) {
    var screen = ShopImagesScreen(images: images);
    var route = CommonMethods.createRouteRTL(screen);
    Navigator.push(context, route);
  }

  // endregion

  // region openMapPopup
  Future<void> openMapPopup(Result shop) async {
    var isAppleMapInstalled = await map.MapLauncher.isMapAvailable(map.MapType.apple);
    var isGoogleMapInstalled = await map.MapLauncher.isMapAvailable(map.MapType.google);
    if (!context.mounted) return;

    // open map popup
    showModalBottomSheet(context: context, builder: (context) => mapPopup(context, isAppleMapInstalled ?? true, isGoogleMapInstalled ?? true, shop));
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
        var marker = getMarker(shop, false);
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

  // region onTapMarker
  Future<void> onTapMarker(Result shop) async {
    // show shop details
    showShopCtrl.value = shop;
    markers.clear();
    
    // generate markers
    for (var shop in shops) {
      var marker = getMarker(shop, shop.name == showShopCtrl.value.name);
      markers.add(marker);
    }

    // refresh mapview
    if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
  }

  // endregion

  // region remove ShopDetails
  void removeShopDetails() {
    // clear shop
    showShopCtrl.value = Result();

    // refresh mapview
    if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
  }

  // endregion

  // region GetMarker
  Marker getMarker(Result shop, bool isSelectedMarker) {
    return Marker(
      draggable: false,
      consumeTapEvents: true,
      visible: true,
      onTap: () => onTapMarker(shop),
      markerId: MarkerId('${shop.lat}${shop.lng}'),
      icon: isSelectedMarker ? selectedMarkerIcon : markerIcon,
      position: LatLng(shop.lat!, shop.lng!),
    );
  }

  // endregion

  // region Dispose
  void dispose() {}
// endregion
}
