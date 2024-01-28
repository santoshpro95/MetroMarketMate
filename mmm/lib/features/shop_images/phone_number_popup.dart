import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/shop_images/shop_images_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'package:mmm/utils/app_strings.dart';

// region phoneNumberPopup
Widget phoneNumberPopup(ShopImagesBloc shopImagesBloc) {
  return Container(
    width: MediaQuery.of(shopImagesBloc.context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(AppStrings.contactNo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
            CupertinoButton(child: const Icon(Icons.close, color: AppColors.background), onPressed: () => Navigator.pop(shopImagesBloc.context)),
          ],
        ),
        const SizedBox(height: 20),
        shopImagesBloc.phoneNumber.isEmpty
            ? const Text("No Result")
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text(shopImagesBloc.phoneNumber[index], style: const TextStyle(fontSize: 20))),
                              CupertinoButton(
                                  onPressed: () => shopImagesBloc.phoneCall(shopImagesBloc.phoneNumber[index]),
                                  padding: EdgeInsets.zero,
                                  child: const Icon(Icons.call, color: AppColors.background)),
                              CupertinoButton(
                                  onPressed: () => shopImagesBloc.whatsapp(shopImagesBloc.phoneNumber[index]),
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(AppImages.whatsapp))
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: shopImagesBloc.phoneNumber.length),
              ),
      ],
    ),
  );
}
// endregion
