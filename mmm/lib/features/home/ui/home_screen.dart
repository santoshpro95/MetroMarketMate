import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmm/features/shops/shops_screen.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_constants.dart';
import 'package:mmm/utils/app_strings.dart';
import '../bloc/home_bloc.dart';

// region HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
// endregion

class _HomeScreenState extends State<HomeScreen> {
  // region Bloc
  late HomeBloc homeBloc;

  // endregion

  // region Init
  @override
  void initState() {
    homeBloc = HomeBloc(context);
    homeBloc.init();
    super.initState();
  }

  // endregion

  // endregion build
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: homeBloc.bottomViewCtrl,
        builder: (context, bottomIndex, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            key: homeBloc.scaffoldKey,
            bottomNavigationBar: bottomNavBar(bottomIndex),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.background,
              toolbarHeight: 0,
              title: Text(AppStrings.appFeature),
            ),
            body: body(bottomIndex),
          );
        });
  }

  // endregion

  // region bottomNavBar
  Widget bottomNavBar(int bottomIndex) {
    return BottomNavigationBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: bottomIndex,
        onTap: (indexValue) => homeBloc.bottomViewCtrl.value = indexValue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Shops"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Mates"),
        ]);
  }

  // endregion

  // region Body
  Widget body(int bottomIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          citySelection(),
          Row(children: [toggleView(), becomeMate()]),
          ShopsScreen(homeBloc: homeBloc)
        ],
      ),
    );
  }

  // endregion

  // region toggleView
  Widget toggleView() {
    return ValueListenableBuilder<bool>(
        valueListenable: homeBloc.toggleViewCtrl,
        builder: (context, value, _) {
          return GestureDetector(
            onTap: () => homeBloc.toggleViewCtrl.value = !value,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.primary),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: value ? AppColors.background : AppColors.primary),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Text(
                          'Map',
                          style: TextStyle(fontWeight: FontWeight.bold, color: value ? Colors.white : AppColors.background),
                        ),
                      )),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: value ? AppColors.primary : AppColors.background),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Center(
                            child: Text(
                          'List',
                          style: TextStyle(fontWeight: FontWeight.bold, color: value ? AppColors.background : Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // endregion

  // region City Selection
  Widget citySelection() {
    return Center(
      child: ValueListenableBuilder<String>(
          valueListenable: homeBloc.citySelectionCtrl,
          builder: (context, snapshot, _) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(30),
                value: snapshot,
                dropdownColor: AppColors.background,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                items: AppConstants.cities.map((String city) {
                  return DropdownMenuItem(
                      value: city, child: Text(city, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)));
                }).toList(),
                onChanged: (String? newValue) => homeBloc.citySelectionCtrl.value = newValue!,
              ),
            );
          }),
    );
  }

  // endregion

// region becomeMate
  Widget becomeMate() {
    return Expanded(
      child: ValueListenableBuilder<bool>(
          valueListenable: homeBloc.mateCtrl,
          builder: (context, data, _) {
            return Row(
              children: [
                const Expanded(child: SizedBox()),
                Text(data ? AppStrings.welcomeMate : AppStrings.becomeMate,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                const SizedBox(width: 10),
                Switch.adaptive(value: data, activeColor: AppColors.primary, onChanged: (value) => homeBloc.loginConfirmation(value)),
              ],
            );
          }),
    );
  }

// endregion
}
