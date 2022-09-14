// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/core/shared/mixin_scaffold.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../core/shared/mixin_validation.dart';
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

class _LoginPageState extends State<LoginPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  IconData currentIcon = Ionicons.eye_outline;
  bool isPasswordObscure = true;
  void updateCurentObscurePasswordIcon() {
    if (currentIcon == Ionicons.eye_off_outline) {
      currentIcon = Ionicons.eye_outline;
      return;
    }
    currentIcon = Ionicons.eye_off_outline;
    return;
  }

  void updateCurrentObscurePasswordValue() {
    if (isPasswordObscure) {
      isPasswordObscure = false;
      return;
    }
    isPasswordObscure = true;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unFocusKeyboard(context);
      },
      child: Scaffold(
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
                          validator: (email) {
                            return isEmailValid(email)
                                ? null
                                : 'Veuillez entrer une adresse email valide';
                          },
                        ),
                        const SizedBox(height: 20),
                        BoxInputField.password(
                          isPasswordTextField: isPasswordObscure,
                          icon: Ionicons.lock_closed_outline,
                          showPassword: IconButton(
                            onPressed: () {
                              setState(() {
                                updateCurentObscurePasswordIcon();
                                updateCurrentObscurePasswordValue();
                              });
                            },
                            icon: Icon(
                              currentIcon,
                              color: const Color(0xFF80808A),
                            ),
                          ),
                          controller: passwordTextFieldController,
                          labelText: 'Mot de passe',
                          validator: (password) {
                            return isPasswordValid(password)
                                ? null
                                : 'Veuillez entrer un mot de passe valide';
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
                          context.goNamed('passwordForgot');
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
                            context.goNamed('register');
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
      ),
    );
  }
}
