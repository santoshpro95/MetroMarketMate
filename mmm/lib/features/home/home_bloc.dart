import 'package:flutter/material.dart';
import 'package:mmm/services/cache_storage/cache_storage_service.dart';
import 'package:mmm/utils/app_constants.dart';

class HomeBloc {
  // region Common Variables
  BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // endregion

  // region Services
  CacheStorageService cacheStorageService = CacheStorageService();

  // endregion

  // region Controller
  final citySelectionCtrl = ValueNotifier(AppConstants.cities.first);
  final toggleViewCtrl = ValueNotifier<bool>(false);

  // endregion

  // region | Constructor |
  HomeBloc(this.context);

  // endregion

  // region Init
  void init() {}

// endregion

// region Dispose
  void dispose() {
    citySelectionCtrl.dispose();
    toggleViewCtrl.dispose();
  }
// endregion
}
