import 'package:flutter/material.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/app_strings.dart';

class HomeBloc {
  // region Common Variables
  BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<NavItems> navItems = [NavItems.home, NavItems.profile, NavItems.orderDetails, NavItems.notification, NavItems.settings];

  // endregion

  // region Controller
  final mateCtrl = ValueNotifier<bool>(false);
  final navCtrl = ValueNotifier<NavItems>(NavItems.home);

  // endregion

  // region | Constructor |
  HomeBloc(this.context);

  // endregion

  // region Init
  void init() {}

// endregion

// region open Screen
  void openScreen(NavItems item) {
    navCtrl.value = item;
    Navigator.pop(context);
  }
// endregion
}

// region NavItems
class NavItems {
  final String icon;
  final String item;

  NavItems(this.icon, this.item);

  static NavItems home = NavItems(AppImages.home, AppStrings.home);
  static NavItems profile = NavItems(AppImages.profile, AppStrings.profile);
  static NavItems settings = NavItems(AppImages.home, AppStrings.settings);
  static NavItems orderDetails = NavItems(AppImages.home, AppStrings.orderDetails);
  static NavItems notification = NavItems(AppImages.home, AppStrings.notification);
}
// endregion
