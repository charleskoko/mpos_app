import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../domain/credential.dart';
import '../infrastructures/authentication_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController passwordTextFieldController = TextEditingController();
  TextEditingController passwordConfirmationTextFieldController =
      TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController mobileTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                  'Enregistrement',
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    BoxInputField.text(
                      controller: nameTextFieldController,
                      labelText: 'Nom et pénoms',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'le nom est obligatroire';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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
                    BoxInputField.number(
                      controller: mobileTextFieldController,
                      labelText: 'telephone',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Telephone est obligatroire';
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
                    ),
                    const SizedBox(height: 20),
                    BoxInputField.password(
                      controller: passwordConfirmationTextFieldController,
                      labelText: 'Repetez votre mot de passe',
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
                  return BoxButton.normal(
                      isBusy: (authenticationState is AuthenticationLoading)
                          ? true
                          : false,
                      title: "s'enregistrer",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Credential credential = Credential(
                            email: emailTextFieldController.text,
                            mobile: mobileTextFieldController.text,
                            name: nameTextFieldController.text,
                            password: passwordTextFieldController.text,
                            password_confirmation:
                                passwordConfirmationTextFieldController.text,
                          );
                          context
                              .read<AuthenticationCubit>()
                              .registration(credential);
                        }
                      });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
