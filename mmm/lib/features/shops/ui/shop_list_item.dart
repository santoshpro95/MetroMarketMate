import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/app_strings.dart';

// region shopListItem
Widget shopListItem(Result shop, ShopsBloc shopsBloc) {
  if (shop.name == null) return const SizedBox();
  return Container(
    height: 110,
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [shopImage(shopsBloc, shop), const SizedBox(width: 10), shopDetails(shopsBloc, shop)],
      ),
    ),
  );
}
// endregion

// region shopImage
Widget shopImage(ShopsBloc shopsBloc, Result shop) {
  return CupertinoButton(
    onPressed: () => shopsBloc.viewImageBtn(shop.images!),
    padding: EdgeInsets.zero,
    child: Stack(
      children: [
        SvgPicture.asset(AppImages.imgPlaceholder, height: 100, width: 100, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: shop.images!.first, fit: BoxFit.cover, height: 100, width: 100)),
      ],
    ),
  );
}
// endregion

// region shopDetails
Widget shopDetails(ShopsBloc shopsBloc, Result shop) {
  return Expanded(
      child: CupertinoButton(
    onPressed: () => shopsBloc.mapBloc.openMapPopup(shop, shopsBloc.context),
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text("${shop.name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.directions, color: AppColors.background),
            const SizedBox(width: 5),
            Text(AppStrings.checkDirection, style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ],
    ),
  ));
}
// endregion
