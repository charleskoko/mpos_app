import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/authentication/infrastructures/reset_password_cubit.dart';
import 'package:mpos_app/src/shared/app_colors.dart';
import '../../core/shared/error_messages.dart';
import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../domain/reset_password_data.dart';
import '../infrastructures/generate_reset_password_code_cubit.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController codeTextFieldController = TextEditingController();
  TextEditingController passwordConfirmationTextFieldController =
      TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  IconData currentIcon = Ionicons.eye_outline;
  bool isPasswordObscure = true;
  @override
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, resetPasswordState) {
          if (resetPasswordState is ResetPasswordLoaded) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              backgroundColor: kPrimaryColor,
              msg: 'mot de passe actualiser avec succés',
            );
          }
          if (resetPasswordState is ResetPasswordError) {
            Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                msg: ErrorMessages.errorMessages(
                    resetPasswordState.authenticationError.getMessage));
          }
        },
        child: ListView(
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
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
                  const SizedBox(
                    width: 220,
                    height: 220,
                    child: Image(
                      image: AssetImage(
                        "assets/images/charly_logo.png",
                      ),
                    ),
                  ),
                  const Text(
                    'Entrez votre nouveau mot de passe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Saisissez le code OTP reçu par email accompagné de votre nouveau mode de passe.",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF656479),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BoxInputField.number(
                          icon: Ionicons.key_outline,
                          controller: codeTextFieldController,
                          labelText: 'Code OTP',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'code OTP est obligatroire';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
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
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  BlocBuilder<GenerateResetPasswordCodeCubit,
                      GenerateResetPasswordCodeState>(
                    builder: (context, generateResetPasswordCodeState) {
                      return BoxButton.main(
                          isBusy: (generateResetPasswordCodeState
                                  is GenerateResetPasswordCodeLoading)
                              ? true
                              : false,
                          title: 'Envoyer',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              ResetPasswordData reserPassWordData =
                                  ResetPasswordData(
                                      code: codeTextFieldController.text,
                                      password:
                                          passwordTextFieldController.text,
                                      password_confirmation:
                                          passwordConfirmationTextFieldController
                                              .text);
                              context.read<ResetPasswordCubit>().resetPassword(
                                  resetPasswordData: reserPassWordData);
                            }
                          });
                    },
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
