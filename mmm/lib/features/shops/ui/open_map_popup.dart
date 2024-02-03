import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/app_strings.dart';
import 'package:mmm/utils/common_methods.dart';

// region mapPopup
Widget mapPopup(BuildContext context, Result shop) {
  return Container(
    color: Colors.transparent,
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        header(shop, context),
        Padding(padding: const EdgeInsets.all(10), child: Text("Check direction of '${shop.name!}' shop on map")),
        googleMap(shop, context),
        appleMap(shop, context),
      ],
    ),
  );
}
// endregion

// region appleMap
Widget appleMap(Result shop, BuildContext context) {
  return Visibility(
    visible: Platform.isIOS,
    child: CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        Navigator.pop(context);
        var url = 'https://maps.apple.com/?q=${shop.lat},${shop.lng}';
        CommonMethods.openUrl(url);
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.primary),
        alignment: Alignment.center,
        child: Row(
          children: [
            SvgPicture.asset(AppImages.apple),
            const SizedBox(width: 10),
            Text(AppStrings.openAppleMap, style: const TextStyle(color: AppColors.background)),
          ],
        ),
      ),
    ),
  );
}
// endregion

// region googleMap
Widget googleMap(Result shop, BuildContext context) {
  return CupertinoButton(
    padding: const EdgeInsets.all(0),
    onPressed: () {
      Navigator.pop(context);
      String url = 'https://www.google.com/maps/search/?api=1&query=${shop.lat},${shop.lng}';
      CommonMethods.openUrl(url);
    },
    child: Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: AppColors.primary),
      alignment: Alignment.center,
      child: Row(
        children: [
          SvgPicture.asset(AppImages.google),
          const SizedBox(width: 10),
          Text(AppStrings.openGoogleMap, style: const TextStyle(color: AppColors.background)),
        ],
      ),
    ),
  );
}
// endregion

// region header
Widget header(Result shop, BuildContext context) {
  return Container(
      height: 50,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), color: AppColors.background),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(AppStrings.checkDirection, style: const TextStyle(color: Colors.white, fontSize: 16)))),
          CupertinoButton(padding: EdgeInsets.zero, child: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))
        ],
      ));
}
// endregion
