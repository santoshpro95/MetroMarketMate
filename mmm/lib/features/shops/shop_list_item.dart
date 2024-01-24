import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';

// region shopListItem
Widget shopListItem(Result shop) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
    margin: const EdgeInsets.only(top: 10),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [shopImage(shop), const SizedBox(width: 10), shopDetails(shop), location()],
      ),
    ),
  );
}
// endregion

// region shopImage
Widget shopImage(Result shop) {
  // check image
  var hasImage = shop.images!.isNotEmpty;

  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 3, color: AppColors.background)),
    height: 100,
    width: 100,
    child: Stack(
      children: [
        SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(AppImages.imgPlaceholder,
                colorFilter: ColorFilter.mode(Colors.grey.withAlpha(80), BlendMode.srcIn), fit: BoxFit.cover),
          ),
        ),
        Visibility(
          visible: !hasImage,
          child: Container(
            color: AppColors.background,
            height: double.maxFinite,
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.fromSize(
                  child: Image.network(
                'https://swarajya.gumlet.io/swarajya/2019-05/6985b1de-36c1-4839-8091-01f3db8d63c9/3983494030_77afbe2c3a_z.jpg',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(.8),
              )),
            ),
          ),
        ),
        Visibility(
          visible: !hasImage,
          child: Align(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                  onPressed: () {},
                  child: SvgPicture.asset(AppImages.images, height: 20, colorFilter: const ColorFilter.mode(AppColors.background, BlendMode.srcIn)))),
        )
      ],
    ),
  );
}
// endregion

// region shopDetails
Widget shopDetails(Result shop) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${shop.name}", style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w800, fontSize: 20)),
        const Text("2.0 Kms away", style: TextStyle(color: AppColors.dropDown, fontWeight: FontWeight.w800, fontSize: 15)),
      ],
    ),
  );
}
// endregion

// region Location
Widget location() {
  return CupertinoButton(onPressed: () {}, child: const Icon(Icons.location_on_outlined, color: AppColors.dropDown));
}
// endregion
