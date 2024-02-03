import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_strings.dart';
import 'package:mmm/utils/custom_google_map.dart';

import 'shop_list_item.dart';

// region googleMap
Widget googleMap(ShopsBloc shopsBloc) {
  return Container(
    padding: const EdgeInsets.only(bottom: 10),
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: StreamBuilder<bool>(
          stream: shopsBloc.mapBloc.mapCtrl.stream,
          builder: (context, snapshot) {
            return ValueListenableBuilder<Result>(
                valueListenable: shopsBloc.mapBloc.showShopCtrl,
                builder: (context, shopDetails, _) {
                  return Stack(
                    children: [
                      GoogleMap(
                          initialCameraPosition: shopsBloc.mapBloc.initialCameraPosition,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          mapType: MapType.hybrid,
                          onTap: (point) => shopsBloc.mapBloc.removeShopDetails(shopsBloc.shops),
                          trafficEnabled: false,
                          markers: shopsBloc.mapBloc.markers,
                          mapToolbarEnabled: true,
                          myLocationButtonEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            shopsBloc.mapBloc.googleMapController = controller;
                            controller.setMapStyle(CustomGoogleMap.customMapStyle());
                          },
                          buildingsEnabled: true),

                      // show shopDetails
                      shopListItem(shopDetails, shopsBloc)
                    ],
                  );
                });
          }),
    ),
  );
}

// endregion
