import 'package:flutter/material.dart';
import 'package:mmm/features/shops/shops_bloc.dart';

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
            return shopList();
          }),
    );
  }

  // endregion

  // region shopList
  Widget shopList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return shopListItem(shopsBloc.shops[index]);
        },
        itemCount: shopsBloc.shops.length);
  }
// endregion
}
