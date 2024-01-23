import 'package:flutter/cupertino.dart';
import 'package:mmm/features/home/ui/home_screen.dart';

class SplashBloc {
  // region Common Methods
  BuildContext context;

  // endregion

  // region | Constructor |
  SplashBloc(this.context);

  // endregion

  // region Init
  void init() {
    // open Home Screen
    openHomeScreen();
  }

  // endregion

  // region OpenHomeScreen
  void openHomeScreen() async {
    // delay for 3 seconds
    await Future.delayed(const Duration(seconds: 1));

    // region open home screen
    var screen = const HomeScreen();
    var route = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    );

    if (!context.mounted) return;
    Navigator.push(context, route);

    // endregion
  }
// endregion
}
