import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../../core/shared/mixin_scaffold.dart';
import '../../../core/shared/mixin_validation.dart';
import '../../../src/shared/app_colors.dart';
import '../../../src/widgets/box_button.dart';
import '../../../src/widgets/box_input_field.dart';
import '../infrastructure/send_receipt_cubit.dart';

class SendReceiptByEmailPage extends StatefulWidget {
  final String orderId;
  SendReceiptByEmailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<SendReceiptByEmailPage> createState() => _SendReceiptByEmailPageState();
}

class _SendReceiptByEmailPageState extends State<SendReceiptByEmailPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController emailTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isEmailSended = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (!isEmailSended)
          ? AppBar(
              leading: const BackButton(
                color: kPrimaryColor,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: BlocListener<SendReceiptCubit, SendReceiptState>(
        listener: (context, sendReceiptState) {
          if (sendReceiptState is SendReceiptLoaded) {
            setState(() {
              isEmailSended = true;
            });
          }
        },
        child: (isEmailSended)
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Ionicons.checkmark_circle_outline, size: 150),
                    const Text(
                      'Reçu envoyé',
                      style: TextStyle(
                        fontFamily: 'Poppins-bold',
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      emailTextFieldController.text,
                      style: const TextStyle(
                        fontFamily: 'Poppins-light',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 21, right: 21),
                      child: BoxButton.main(
                          title: 'Nouvelle vente',
                          onTap: () {
                            context.read<SendReceiptCubit>().initialize();
                            context.goNamed('main', params: {'tab': '2'});
                          }),
                    )
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.only(
                  top: 150,
                  left: 21,
                  right: 21,
                ),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BoxInputField.email(
                          autofocus: true,
                          icon: Ionicons.mail_outline,
                          controller: emailTextFieldController,
                          labelText: 'Adresse e-mail',
                          validator: (email) {
                            return isEmailValid(email)
                                ? null
                                : 'Veuillez entrer une adresse email valide';
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SendReceiptCubit, SendReceiptState>(
                          builder: (context, sendReceiptState) {
                            return BoxButton.main(
                                isBusy: (sendReceiptState is SendReceiptLoading)
                                    ? true
                                    : false,
                                title: 'Envoyer un reçu',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    Map<String, dynamic> data = {
                                      'order_id': widget.orderId,
                                      'email': emailTextFieldController.text
                                    };
                                    context
                                        .read<SendReceiptCubit>()
                                        .sendReceipt(data);
                                  }
                                });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Indiquez votre adresse e-mail pour recevoir un reçu électronique de la part de ce commercant.',
                          style: TextStyle(
                            fontFamily: 'Poppins-light',
                            fontSize: 13,
                          ),
                        )
                      ],
                    )),
              ),
      ),
    );
  }
}
