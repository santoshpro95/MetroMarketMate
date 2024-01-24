import 'package:flutter/material.dart';
import 'package:mmm/features/home/bloc/home_bloc.dart';
import 'package:mmm/features/shops/shops_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
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
          if (isMapView) return mapView();
          return shopList();
        });
  }

  // endregion

  // region mapView
  Widget mapView() {
    return Container();
  }

  // endregion

  // region shopList
  Widget shopList() {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(shopsBloc.shops.length, (index) {
          return shopListItem(shopsBloc.shops[index]);
        }));
  }
// endregion
}
