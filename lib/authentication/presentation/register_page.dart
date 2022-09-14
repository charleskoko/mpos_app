import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/authentication/domain/credential.dart';

import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../infrastructures/authentication_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController mobileTextFieldController = TextEditingController();
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController passwordConfirmationTextFieldController =
      TextEditingController();

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
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 41,
                            width: 41,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFEAEAEA),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Ionicons.chevron_back,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: SizedBox(
                          width: 214,
                          height: 214,
                          child: Image(
                            image: AssetImage(
                              "assets/images/charly_logo.png",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: BoxText.appBarTitle("S'inscrire"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BoxInputField.text(
                          icon: Ionicons.person_outline,
                          controller: nameTextFieldController,
                          labelText: 'Nom du maquis',
                          validator: (text) {
                            return isTextfieldNotEmpty(text)
                                ? null
                                : 'Veuillez entrer Le nom de votre établissement';
                          },
                        ),
                        const SizedBox(height: 15),
                        BoxInputField.email(
                          icon: Ionicons.mail_outline,
                          controller: emailTextFieldController,
                          labelText: 'Adresse email',
                          validator: (email) {
                            return isEmailValid(email)
                                ? null
                                : 'Veuillez entrer un mot de passe valide';
                          },
                        ),
                        const SizedBox(height: 15),
                        BoxInputField.number(
                          icon: Ionicons.phone_portrait_outline,
                          controller: mobileTextFieldController,
                          labelText: 'Telephone',
                          validator: (phoneNumber) {
                            return isPhoneNumberValid(phoneNumber)
                                ? null
                                : 'Veuillez entrer un numéro de telephone valide';
                          },
                        ),
                        const SizedBox(height: 15),
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
                                : 'Veuillez entrer un mot de passe avec 8 digits minimum';
                          },
                        ),
                        const SizedBox(height: 15),
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
                          controller: passwordConfirmationTextFieldController,
                          labelText: 'Confirmer le mot de passe',
                          validator: (value) {
                            return isPasswordConfirmed(
                                    value, passwordTextFieldController.text)
                                ? null
                                : "Le mot de passe n'est pas identique au précédent";
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, authenticationState) {
                      return BoxButton.main(
                          isBusy: (authenticationState is AuthenticationLoading)
                              ? true
                              : false,
                          title: "S'ENREGISTRER",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Credential credential = Credential(
                                name: nameTextFieldController.text,
                                email: emailTextFieldController.text,
                                mobile: mobileTextFieldController.text,
                                password: passwordTextFieldController.text,
                                password_confirmation:
                                    passwordConfirmationTextFieldController
                                        .text,
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
                        BoxText.caption("Vous avez déjà un compte?",
                            color: const Color(0xFF80808A)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: BoxText.caption(
                            "Se connecter",
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
