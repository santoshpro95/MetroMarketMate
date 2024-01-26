import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/home/home_bloc.dart';
import 'package:mmm/features/shops/shops_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/custom_google_map.dart';
import 'shop_list_item.dart';

// region ShopsScreen
class ShopsScreen extends StatefulWidget {
  final HomeBloc homeBloc;

  const ShopsScreen({Key? key, required this.homeBloc}) : super(key: key);

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}
// endregion

class _ShopsScreenState extends State<ShopsScreen> {
  // region Bloc
  late ShopsBloc shopsBloc;

  // endregion

  // region Init
  @override
  void initState() {
    shopsBloc = ShopsBloc(context, widget.homeBloc);
    shopsBloc.init();
    super.initState();
  }

  // endregion

  // region Dispose
  @override
  void dispose() {
    shopsBloc.dispose();
    super.dispose();
  }

  // endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<ShopStatus>(
            stream: shopsBloc.shopCtrl.stream,
            initialData: ShopStatus.Loading,
            builder: (context, snapshot) {
              // loading
              if (snapshot.data! == ShopStatus.Loading) return const Center(child: CircularProgressIndicator());

              // failure
              if (snapshot.data! == ShopStatus.Failure) return const Center(child: Text("Failed, try again"));

              // empty
              if (snapshot.data! == ShopStatus.Empty) return const Center(child: Text("No Result"));

              // success
              return shopView();
            }));
  }

  // endregion

  // region shopView
  Widget shopView() {
    return ValueListenableBuilder<bool>(
        valueListenable: shopsBloc.homeBloc.toggleViewCtrl,
        builder: (context, isMapView, _) {
          return IndexedStack(
            index: isMapView ? 0 : 1,
            children: [googleMap(), shopList()],
          );
        });
  }

  // endregion

  // region googleMap
  Widget googleMap() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: StreamBuilder<bool>(
            stream: shopsBloc.mapCtrl.stream,
            builder: (context, snapshot) {
              return GoogleMap(
                  initialCameraPosition: shopsBloc.initialCameraPosition,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  trafficEnabled: true,
                  markers: shopsBloc.markers,
                  mapToolbarEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    shopsBloc.googleMapController = controller;
                    controller.setMapStyle(CustomGoogleMap.customMapStyle());
                  },
                  buildingsEnabled: true);
            }),
      ),
    );
  }

// endregion

  // region shopList
  Widget shopList() {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        children: List<Widget>.generate(shopsBloc.shops.length, (index) {
          return shopListItem(shopsBloc.shops[index], shopsBloc, context);
        }));
  }
// endregion
}
