import 'package:flutter/material.dart';
import 'package:mmm/features/splash/splash_screen.dart';

// region App
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // region Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/splash': (context) => const SplashScreen()},
      initialRoute: '/splash',
    );
  }
// endregion
}
// endregion
