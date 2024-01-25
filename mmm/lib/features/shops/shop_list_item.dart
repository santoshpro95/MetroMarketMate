import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/shops/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/app_strings.dart';

// region shopListItem
Widget shopListItem(Result shop, ShopsBloc shopsBloc) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
    margin: const EdgeInsets.only(top: 10),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [shopImage(shop, shopsBloc), const SizedBox(width: 10), shopDetails(shop)],
      ),
    ),
  );
}
// endregion

// region shopImage
Widget shopImage(Result shop, ShopsBloc shopsBloc) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 3, color: AppColors.background)),
      child: Stack(
        children: [
          noImage(),
          shop.images!.isNotEmpty
              ? Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: AppColors.background,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), child: SizedBox.fromSize(child: Image.network(shop.images!.first, fit: BoxFit.cover))))
              : const SizedBox(),
          viewImageBtn(shop.images!, shopsBloc)
        ],
      ),
    ),
  );
}
// endregion

// region viewImageBtn
Widget viewImageBtn(List<String> images, ShopsBloc shopsBloc) {
  if (images.isEmpty) return const SizedBox();
  return Align(
      alignment: Alignment.bottomRight,
      child: CupertinoButton(
          onPressed: () => shopsBloc.viewImageBtn(images),
          padding: EdgeInsets.zero,
          child: SvgPicture.asset(AppImages.images, height: 20, colorFilter: const ColorFilter.mode(AppColors.background, BlendMode.srcIn))));
}
// endregion

// region NoImage
Widget noImage() {
  return Stack(
    children: [
      SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SvgPicture.asset(AppImages.imgPlaceholder, colorFilter: ColorFilter.mode(Colors.grey.withAlpha(80), BlendMode.srcIn)),
        ),
      ),
      const Center(child: Text("No Image", style: TextStyle(color: Colors.black54)))
    ],
  );
}
// endregion

// region shopDetails
Widget shopDetails(Result shop) {
  return CupertinoButton(
    onPressed: () {},
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text("${shop.name}", maxLines: 2, style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w800, fontSize: 16)),
        Row(
          children: [
            const Icon(Icons.directions, color: AppColors.background),
            const SizedBox(width: 5),
            Text(AppStrings.checkDirection, style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}
// endregion
