import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/shared/app_colors.dart';

import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../domain/credential.dart';
import '../infrastructures/authentication_cubit.dart';
import '../infrastructures/generate_reset_password_code_cubit.dart';

class PasswordForgotPage extends StatefulWidget {
  const PasswordForgotPage({Key? key}) : super(key: key);

  @override
  State<PasswordForgotPage> createState() => _PasswordForgotPageState();
}

class _PasswordForgotPageState extends State<PasswordForgotPage> {
  TextEditingController emailTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GenerateResetPasswordCodeCubit,
          GenerateResetPasswordCodeState>(
        listener: (context, generateResetPasswordCodeState) {
          if (generateResetPasswordCodeState
              is GenerateResetPasswordCodeLoaded) {
            context.goNamed('passwordReset');
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              backgroundColor: kPrimaryColor,
              msg: 'Code envoyé avec succès. Verifier vos emails.',
            );
          }
          if (generateResetPasswordCodeState
              is GenerateResetPasswordCodeError) {
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              msg:
                  generateResetPasswordCodeState.authenticationError.getMessage,
            );
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
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 242,
                    height: 242,
                    child: Image(
                      image: AssetImage(
                        "assets/images/charly_logo.png",
                      ),
                    ),
                  ),
                  const Text(
                    'NOUVEAU MOT DE PASSE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Saisissez votre adresse électronique associée à votre compte. Nous vous enverrons un OTP pour réinitialiser votre mot de passe.",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
                        color: Color(0xFF656479),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 31),
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
                              Credential credential = Credential(
                                  email: emailTextFieldController.text);
                              context
                                  .read<GenerateResetPasswordCodeCubit>()
                                  .generateResetPasswordcode(
                                      credential: credential);
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
