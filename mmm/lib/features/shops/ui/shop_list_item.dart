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
Widget shopListItem(Result shop, ShopsBloc shopsBloc, BuildContext context) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
    margin: const EdgeInsets.only(top: 10),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [shopImage(shop, shopsBloc), const SizedBox(width: 10), shopDetails(shop, context, shopsBloc)],
      ),
    ),
  );
}
// endregion

// region shopImage
Widget shopImage(Result shop, ShopsBloc shopsBloc) {
  return Expanded(
    child: Stack(
      children: [
        noImage(),
        shop.images!.isNotEmpty
            ? CupertinoButton(
                onPressed: () => shopsBloc.viewImageBtn(shop.images!),
                padding: EdgeInsets.zero,
                child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox.fromSize(child: CachedNetworkImage(imageUrl: shop.images!.first, fit: BoxFit.cover)))),
              )
            : const SizedBox()
      ],
    ),
  );
}
// endregion

// region NoImage
Widget noImage() {
  return SizedBox(
    height: double.maxFinite,
    width: double.maxFinite,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: SvgPicture.asset(AppImages.imgPlaceholder, colorFilter: ColorFilter.mode(Colors.grey.withAlpha(80), BlendMode.srcIn)),
    ),
  );
}
// endregion

// region shopDetails
Widget shopDetails(Result shop, BuildContext context, ShopsBloc shopsBloc) {
  return CupertinoButton(
    onPressed: () => shopsBloc.openMapPopup(shop),
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
