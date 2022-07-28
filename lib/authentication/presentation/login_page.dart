// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/snack_bar.dart';
import '../../src/shared/app_colors.dart';
import '../../src/shared/styles.dart';
import '../../src/widgets/box_text.dart';
import '../domain/credential.dart';
import '../infrastructures/authentication_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, authenticationState) {
          if (authenticationState is AuthenticationValidated) {
            context.goNamed('main');
          }
          if (authenticationState is AuthenticationNotValidated) {}
          if (authenticationState is AuthenticationFailed) {
            buidSnackbar(
              context: context,
              backgroundColor: Colors.red,
              text: authenticationState.message,
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.only(
            left: 55,
            right: 55,
            top: 100,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                  ),
                  child: BoxText.headingOne(
                    'mPOS',
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextFieldController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: subheadingStyle.copyWith(
                            color: kblackColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email est obligatroire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordTextFieldController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: subheadingStyle.copyWith(
                            color: kblackColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Mot de passe obligatoire';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.5),
                        offset: Offset(0, 24),
                        blurRadius: 50,
                        spreadRadius: -18,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        print('form validated');
                      }
                      Credential credential = Credential(
                          email: emailTextFieldController.text,
                          password: passwordTextFieldController.text);
                      context.read<AuthenticationCubit>().login(credential);
                    },
                    child: Container(
                        child: Center(
                          child: BoxText.subheading(
                            'Se connecter',
                            color: Colors.white,
                          ),
                        ),
                        width: size.width - 110,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              kPrimaryColorGradient,
                              kPrimaryColorDark,
                            ],
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 25,
                    bottom: 10,
                  ),
                  child: BoxText.caption(
                    'Mot de passe oublié?',
                  ),
                ),
                const SizedBox(width: 100, child: Divider()),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: BoxText.caption(
                    'S\'enregistrer',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
