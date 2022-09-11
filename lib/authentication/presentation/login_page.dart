// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/shared/app_colors.dart';
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
            String errorKey =
                ErrorMessage.determineMessageKey(authenticationState.message);
            buidSnackbar(
              context: context,
              backgroundColor: Colors.red,
              text: ErrorMessage.errorMessages[errorKey] ??
                  'Une erreur a eu lieu. Veuillez réessayer',
            );
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            left: 28,
            right: 28,
            top: 52,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 242,
                  height: 242,
                  child: Image(
                    image: AssetImage(
                      "assets/images/charly_logo.png",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: BoxText.appBarTitle('Se Connecter'),
                ),
                const SizedBox(height: 12),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BoxInputField.email(
                        icon: Ionicons.mail_outline,
                        controller: emailTextFieldController,
                        labelText: 'Adresse email',
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
                        icon: Ionicons.lock_closed_outline,
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
                const SizedBox(height: 26),
                Container(
                  alignment: Alignment.centerRight,
                  height: 23,
                  child: GestureDetector(
                      onTap: () {
                        print('navigate to password reset page');
                      },
                      child: BoxText.body('Mot de passe oublié?')),
                ),
                const SizedBox(height: 23),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  builder: (context, authenticationState) {
                    return BoxButton.main(
                        isBusy: (authenticationState is AuthenticationLoading)
                            ? true
                            : false,
                        title: 'Se connecter',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            Credential credential = Credential(
                              email: emailTextFieldController.text,
                              password: passwordTextFieldController.text,
                            );
                            context
                                .read<AuthenticationCubit>()
                                .login(credential);
                          }
                        });
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoxText.caption("Vous n'avez pas de compte? ",
                          color: const Color(0xFF80808A)),
                      GestureDetector(
                        onTap: () {
                          print('Nqvigate to register page');
                        },
                        child: BoxText.caption(
                          "Inscrivez-vous",
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 38),
              ],
            )
          ],
        ),
      ),
    );
  }
}
