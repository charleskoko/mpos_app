import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<AuthenticationCubit>().isUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, authenticationState) {
          if (authenticationState is AuthenticationLoading) {}
          if (authenticationState is AuthenticationValidated) {
            context.goNamed('main');
          }
          if (authenticationState is AuthenticationNotValidated) {
            context.goNamed('login');
          }
          if (authenticationState is AuthenticationFailed) {}
        },
        child: Container(),
      ),
    );
  }
}
