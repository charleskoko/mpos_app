// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/presentation/snack_bar.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
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
                      BoxInputField.email(
                        controller: emailTextFieldController,
                        labelText: 'Email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email est obligatroire';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BoxInputField.password(
                        controller: passwordTextFieldController,
                        labelText: 'Mot de passe',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mot de passe obligatoire';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  builder: (context, authenticationState) {
                    return BoxButton(
                        isBusy: (authenticationState is AuthenticationLoading)
                            ? true
                            : false,
                        title: 'Se connecter',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            Credential credential = Credential(
                                email: emailTextFieldController.text,
                                password: passwordTextFieldController.text);
                            context
                                .read<AuthenticationCubit>()
                                .login(credential);
                          }
                        });
                  },
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
