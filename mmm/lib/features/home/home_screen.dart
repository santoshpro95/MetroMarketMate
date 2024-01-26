import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmm/features/shops/ui/shops_screen.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_constants.dart';
import 'package:mmm/utils/app_strings.dart';
import 'home_bloc.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      key: homeBloc.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        toolbarHeight: 0,
      ),
      body: body(),
    );
  }

  // endregion

  // region Body
  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(children: [toggleView(), const Expanded(child: SizedBox()), citySelection()]),
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
    return ValueListenableBuilder<String>(
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
        });
  }

// endregion
}
