import 'package:flutter/material.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';
import 'splash_bloc.dart';

// region SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
// endregion

class _SplashScreenState extends State<SplashScreen> {
  // region Bloc
  late SplashBloc splashBloc;

  // endregion

  // region Init
  @override
  void initState() {
    splashBloc = SplashBloc(context);
    splashBloc.init();
    super.initState();
  }

  // endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(),
    );
  }

  // endregion

  // region body
  Widget body() {
    return Center(
      child: Image.asset(AppImages.logo, height: MediaQuery.of(context).size.width / 1.3),
    );
  }
// endregion
}
