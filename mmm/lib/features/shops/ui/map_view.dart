import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/custom_google_map.dart';
import 'shop_list_item.dart';

// region googleMap
Widget googleMap(ShopsBloc shopsBloc) {
  return Container(
    padding: const EdgeInsets.only(bottom: 10),
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [mapView(shopsBloc), selectedShop(shopsBloc)],
      ),
    ),
  );
}

// endregion

// region selectedShop
Widget selectedShop(ShopsBloc shopsBloc) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ValueListenableBuilder<Result>(
          valueListenable: shopsBloc.mapBloc.showShopCtrl,
          builder: (context, shopDetails, _) {
            return shopListItem(shopDetails, shopsBloc);
          }),
    ),
  );
}
// endregion

// region mapView
Widget mapView(ShopsBloc shopsBloc) {
  return StreamBuilder<bool>(
      stream: shopsBloc.mapBloc.mapCtrl.stream,
      builder: (context, snapshot) {
        return GoogleMap(
            initialCameraPosition: shopsBloc.mapBloc.initialCameraPosition,
            myLocationEnabled: false,
            compassEnabled: true,
            mapType: MapType.normal,
            onTap: (point) => shopsBloc.mapBloc.removeShopDetails(shopsBloc.allShops),
            trafficEnabled: false,
            markers: shopsBloc.mapBloc.markers,
            mapToolbarEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller)=> shopsBloc.mapBloc.onMapCreated(controller) ,
            buildingsEnabled: true);
      });
}
// endregion
