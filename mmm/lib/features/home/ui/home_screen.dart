import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/shops/shops_screen.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_constants.dart';
import 'package:mmm/utils/app_images.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      key: homeBloc.scaffoldKey,
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: AppColors.background, toolbarHeight: 0, title: Text(AppStrings.appFeature)),
      body: body(),
    );
  }

  // endregion

  // region Body
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          citySelection(),
          becomeMate(),
          const ShopsScreen()
        ],
      ),
    );
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
    return ValueListenableBuilder<bool>(
        valueListenable: homeBloc.mateCtrl,
        builder: (context, data, _) {
          return Row(
            children: [
              const Expanded(child: SizedBox()),
              Text(data ? AppStrings.welcomeMate : AppStrings.becomeMate,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20)),
              const SizedBox(width: 10),
              Switch.adaptive(value: data, activeColor: AppColors.primary, onChanged: (value) => homeBloc.loginConfirmation(value)),
            ],
          );
        });
  }

// endregion
}
