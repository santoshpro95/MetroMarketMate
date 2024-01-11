import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/features/home/nav_bar.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
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
      key: homeBloc.scaffoldKey,
      drawer: navBar(homeBloc),
      backgroundColor: AppColors.background,
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0, backgroundColor: Colors.transparent, title: Text(AppStrings.appFeature)),
      body: body(),
    );
  }

  // endregion

  // region Body
  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [becomeMate()],
      ),
    );
  }

  // endregion

// region becomeMate
  Widget becomeMate() {
    return Row(
      children: [
        sideBar(),
        Text(AppStrings.becomeMate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 21)),
        const SizedBox(width: 10),
        ValueListenableBuilder<bool>(
            valueListenable: homeBloc.mateCtrl,
            builder: (context, value, _) {
              return Switch.adaptive(value: value, activeColor: AppColors.primary, onChanged: (value) => homeBloc.mateCtrl.value = value);
            })
      ],
    );
  }

// endregion

// region sideBar
  Widget sideBar() {
    return Expanded(
        child: Container(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
                onPressed: () => homeBloc.scaffoldKey.currentState!.openDrawer(),
                padding: EdgeInsets.zero,
                child: SvgPicture.asset(AppImages.nav, height: 40, width: 40))));
  }
// endregion
}
