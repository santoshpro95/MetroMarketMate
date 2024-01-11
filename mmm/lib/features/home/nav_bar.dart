import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/home/home_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';

// region Nav Bar
Widget navBar(HomeBloc homeBloc) {
  return Drawer(
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    backgroundColor: AppColors.primary,
    child: ValueListenableBuilder<NavItems>(
        valueListenable: homeBloc.navCtrl,
        builder: (context, selected, _) {
          return Column(
            children: [
              const SizedBox(height: 80),
              const CircleAvatar(radius: 50, backgroundImage: AssetImage(AppImages.logo)),
              const SizedBox(height: 20),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return navItem(selected, homeBloc.navItems[index], homeBloc);
                  },
                  itemCount: homeBloc.navItems.length)
            ],
          );
        }),
  );
}

// endregion

// region navItems
Widget navItem(NavItems selected, NavItems navItems, HomeBloc homeBloc) {
  return Container(
    height: 60,
    margin: const EdgeInsets.only(left: 20, top: 20),
    width: double.maxFinite,
    decoration: BoxDecoration(
        color: selected == navItems ? AppColors.background : Colors.transparent,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
    child: CupertinoButton(
        onPressed: () => homeBloc.openScreen(navItems),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            SvgPicture.asset(navItems.icon, width: 30, colorFilter: ColorFilter.mode(selected == navItems ? Colors.white : AppColors.background, BlendMode.srcIn)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                navItems.item,
                style: TextStyle(color: selected == navItems ? Colors.white : AppColors.background, fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        )),
  );
}
// endregion
