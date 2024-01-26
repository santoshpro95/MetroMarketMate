import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mmm/features/home/home_bloc.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_strings.dart';
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
              return ValueListenableBuilder<Result>(
                  valueListenable: shopsBloc.showShopCtrl,
                  builder: (context, shopDetails, _) {
                    return Stack(
                      children: [
                        GoogleMap(
                            initialCameraPosition: shopsBloc.initialCameraPosition,
                            myLocationEnabled: true,
                            compassEnabled: true,
                            mapType: MapType.normal,
                            onTap: (point) => shopsBloc.removeShopDetails(),
                            trafficEnabled: false,
                            markers: shopsBloc.markers,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              shopsBloc.googleMapController = controller;
                              controller.setMapStyle(CustomGoogleMap.customMapStyle());
                            },
                            buildingsEnabled: true),

                        // show shopDetails
                        showShop(shopDetails)
                      ],
                    );
                  });
            }),
      ),
    );
  }

// endregion

  // region showShop
  Widget showShop(Result shop) {
    if (shop.name == null) return const SizedBox();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: AppColors.background, blurRadius: 3, spreadRadius: 1, offset: Offset(0, 0))],
            color: AppColors.primary),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoButton(
                onPressed: () => shopsBloc.viewImageBtn(shop.images!),
                padding: EdgeInsets.zero,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: AppColors.background),
                      color: AppColors.background),
                  height: 100,
                  child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(shop.images!.first, fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: CupertinoButton(
                onPressed: () => shopsBloc.openMapPopup(shop),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("${shop.name}", maxLines: 2, style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.directions, color: AppColors.background),
                        const SizedBox(width: 5),
                        Text(AppStrings.checkDirection,
                            style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              )),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => shopsBloc.removeShopDetails(),
                  child: const Icon(Icons.close, color: AppColors.background))
            ],
          ),
        ),
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
