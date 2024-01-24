import 'package:flutter/material.dart';
import 'package:mmm/features/register/register_bloc.dart';
import 'package:mmm/utils/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // region Bloc
  late RegisterBloc loginBloc;

  // endregion

  // region Init
  @override
  void initState() {
    loginBloc = RegisterBloc(context);
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
      appBar: AppBar(backgroundColor: AppColors.background, foregroundColor: Colors.white, elevation: 0),
      backgroundColor: AppColors.background,
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
