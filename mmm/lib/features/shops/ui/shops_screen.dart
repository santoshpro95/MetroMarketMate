import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/features/shops/ui/header_filter.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/common_widgets.dart';
import 'map_view.dart';
import 'search_shop.dart';
import 'shop_list_item.dart';

// region ShopsScreen
class ShopsScreen extends StatefulWidget {
  const ShopsScreen({Key? key}) : super(key: key);

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
    shopsBloc = ShopsBloc(context);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: AppColors.background, toolbarHeight: 0),
      body: body(),
    );
  }

  // endregion

  // region body
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          header(shopsBloc),
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: shopsBloc.toggleViewCtrl,
                  builder: (context, isMapView, _) {
                    return IndexedStack(
                      index: isMapView ? 0 : 1,
                      children: [
                        googleMap(shopsBloc),
                        StreamBuilder<ShopStatus>(
                            stream: shopsBloc.shopCtrl.stream,
                            initialData: ShopStatus.Loading,
                            builder: (context, snapshot) {
                              // loading
                              if (snapshot.data! == ShopStatus.Loading) return const Center(child: CircularProgressIndicator());

                              // failure
                              if (snapshot.data! == ShopStatus.Failure) return const Center(child: Text("Failed, try again"));

                              // empty
                              if (snapshot.data! == ShopStatus.Empty) return CommonWidgets.noResult();

                              // success
                              return shopView();
                            }),
                        fullScreenLoading()
                      ],
                    );
                  })),
        ],
      ),
    );
  }

  // endregion

  // region fullScreenLoading
  Widget fullScreenLoading() {
    return StreamBuilder<bool>(
        stream: shopsBloc.loadingCtrl.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data!,
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withAlpha(90)),
              child: const Center(
                child: Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300)),
              ),
            ),
          );
        });
  }

  // endregion

  // region shopView
  Widget shopView() {
    return ValueListenableBuilder<bool>(
        valueListenable: shopsBloc.toggleViewCtrl,
        builder: (context, isMapView, _) {
          return IndexedStack(
            index: isMapView ? 0 : 1,
            children: [googleMap(shopsBloc), shopList()],
          );
        });
  }

  // endregion

  // region shopList
  Widget shopList() {
    return Column(
      children: [
        searchShop(shopsBloc),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return shopListItem(shopsBloc.searchedShop[index], shopsBloc);
              },
              itemCount: shopsBloc.searchedShop.length),
        ),
      ],
    );
  }
// endregion
}
