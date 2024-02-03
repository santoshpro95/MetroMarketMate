import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';

// region searchShop
Widget searchShop(ShopsBloc shopsBloc) {
  return Container(
    height: 45,
    margin: const EdgeInsets.only(top: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
           Expanded(
              child: TextField(
                onChanged: (text)=> shopsBloc.searchBloc.onSearch(text),
            decoration: const InputDecoration.collapsed(hintText: "Search by shop name"),
          )),
          SvgPicture.asset(AppImages.search)
        ],
      ),
    ),
  );
}
// endregion
