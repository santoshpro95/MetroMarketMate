import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mmm/features/register/register_screen.dart';
import 'package:mmm/services/cache_storage/cache_storage_service.dart';
import 'package:mmm/services/cache_storage/storage_keys.dart';
import 'package:mmm/utils/app_constants.dart';
import 'package:mmm/utils/app_strings.dart';
import 'package:mmm/utils/common_methods.dart';
import 'package:mmm/utils/common_widgets.dart';

class HomeBloc {
  // region Common Variables
  BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // endregion

  // region Services
  CacheStorageService cacheStorageService = CacheStorageService();

  // endregion

  // region Controller
  final mateCtrl = ValueNotifier<bool>(false);
  final citySelectionCtrl = ValueNotifier(AppConstants.cities.first);
  final toggleViewCtrl = ValueNotifier<bool>(false);
  final bottomViewCtrl = ValueNotifier<int>(0);
  // endregion

  // region | Constructor |
  HomeBloc(this.context);

  // endregion

  // region Init
  void init() {
    checkMateStatus();
  }

// endregion

  // region checkMateStatus
  Future<void> checkMateStatus() async {
    var hasData = await cacheStorageService.containsKey(StorageKeys.SavedMateKey);
    if (hasData) {
      var getData = await cacheStorageService.getBoolean(StorageKeys.SavedMateKey);
      mateCtrl.value = getData;
      await cacheStorageService.saveBoolean(StorageKeys.SavedMateKey, getData);
    } else {
      // default mate status
      await cacheStorageService.saveBoolean(StorageKeys.SavedMateKey, mateCtrl.value);
    }
  }

  // endregion

  // region Login Confirmation
  void loginConfirmation(var value) {
    mateCtrl.value = value;
    if (!value) return;

    /// need to check if already logged in, then no need to show confirmation dialog
    CommonWidgets.confirmationBox(context, AppStrings.loginConfirm, AppStrings.loginConfirmMsg, openLoginScreen, cancelLogin);
  }

  // endregion

  // region cancelLogin
  void cancelLogin() {
    // close popup
    Navigator.pop(context);
    mateCtrl.value = false;
  }

  // endregion

  // region openLoginScreen
  void openLoginScreen() async {
    await cacheStorageService.saveBoolean(StorageKeys.SavedMateKey, mateCtrl.value);
    if (!context.mounted) return;

    // close popup
    Navigator.pop(context);

    // open login screen
    var screen = const RegisterScreen();
    var route = CommonMethods.createRouteRTL(screen);
    Navigator.push(context, route);
  }

  // endregion

// region Dispose
  void dispose() {}
// endregion
}
