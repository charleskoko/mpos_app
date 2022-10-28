import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_input_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: kPrimaryColor),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
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
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> data = {
                        'order_id': widget.orderId,
                        'email': emailTextFieldController.text
                      };
                      print(data);
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF262262),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        'Envoyer un reçu',
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
    );
  }
}
