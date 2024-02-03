import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/shops/ui/open_map_popup.dart';
import 'package:mmm/model/get_shops_response.dart';

class MapBloc {
  // region Google Map
  late Completer<GoogleMapController> controller = Completer();
  late GoogleMapController googleMapController;
  CameraPosition initialCameraPosition = const CameraPosition(target: LatLng(28.490147, 77.094030), zoom: 15);
  Set<Marker> markers = HashSet<Marker>();
  late BitmapDescriptor markerIcon;
  late BitmapDescriptor selectedMarkerIcon;

  // endregion

  // region Controller
  final mapCtrl = StreamController<bool>.broadcast();
  final showShopCtrl = ValueNotifier(Result());

  // endregion

  // region | Constructor |
  MapBloc();

  // endregion

  // region initMap
  Future<void> initMap() async {
    markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    selectedMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  }

// endregion

  // region openMapPopup
  Future<void> openMapPopup(Result shop, BuildContext context) async {
    showModalBottomSheet(context: context, builder: (context) => mapPopup(context, shop));
  }

// endregion

  // region onTapMarker
  Future<void> onTapMarker(Result shop, List<Result> shops) async {
    // show shop details
    showShopCtrl.value = shop;
    markers.clear();

    // generate markers
    for (var shop in shops) {
      var marker = getMarker(shop, shop.name == showShopCtrl.value.name, shops);
      markers.add(marker);
    }

    // refresh mapview
    if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
  }

// endregion

  // region remove ShopDetails
  void removeShopDetails(List<Result> shops) {
    // clear shop
    showShopCtrl.value = Result();
    markers.clear();

    // generate markers
    for (var shop in shops) {
      var marker = getMarker(shop, false, shops);
      markers.add(marker);
    }

    // refresh mapview
    if (!mapCtrl.isClosed) mapCtrl.sink.add(true);
  }

// endregion

  // region GetMarker
  Marker getMarker(Result shop, bool isSelectedMarker, List<Result> shops) {
    return Marker(
      draggable: false,
      consumeTapEvents: true,
      visible: true,
      onTap: () => onTapMarker(shop, shops),
      markerId: MarkerId('${shop.lat}${shop.lng}'),
      icon: isSelectedMarker ? selectedMarkerIcon : markerIcon,
      position: LatLng(shop.lat!, shop.lng!),
    );
  }

// endregion

// region Dispose
  void dispose() {
    mapCtrl.close();
    showShopCtrl.dispose();
  }
// endregion
}
