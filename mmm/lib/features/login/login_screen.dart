import 'package:flutter/material.dart';
import 'package:mmm/features/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // region Bloc
  late LoginBloc loginBloc;

  // endregion

  // region Init
  @override
  void initState() {
    loginBloc = LoginBloc(context);
    loginBloc.init();
    super.initState();
  }

  // endregion

  // region Dispose
  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  //endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  // endregion

  // region body
  Widget body() {
    return Container();
  }
// endregion
}
