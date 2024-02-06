import 'package:flutter/cupertino.dart';
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
      child: StreamBuilder<bool>(
          stream: shopsBloc.searchBloc.searchCtrl.stream,
          initialData: true,
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: shopsBloc.searchBloc.searchTextCtrl,
                  onChanged: (text) => shopsBloc.searchBloc.onSearch(text, shopsBloc),
                  decoration: const InputDecoration.collapsed(hintText: "Search by shop name"),
                )),
                snapshot.data!
                    ? SvgPicture.asset(AppImages.search)
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.close, color: AppColors.background),
                        onPressed: () => shopsBloc.searchBloc.clearSearch(shopsBloc))
              ],
            );
          }),
    ),
  );
}
// endregion
