import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../src/shared/app_colors.dart';

class PaymentOptionsPage extends StatefulWidget {
  final double sum;
  final String isNotProcessedOrder;
  const PaymentOptionsPage(
      {Key? key, required this.sum, required this.isNotProcessedOrder})
      : super(key: key);

  @override
  State<PaymentOptionsPage> createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.close, color: Colors.black, size: 35),
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 130),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                '${widget.sum} FCFA',
                style: const TextStyle(
                  fontFamily: 'Poppins-bold',
                  color: kPrimaryColor,
                  fontSize: 35,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                'Choisissez un type de paiement ci-dessous.',
                style: TextStyle(
                  fontFamily: 'Poppins-light',
                  color: kPrimaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          GestureDetector(
              onTap: () {
                context.pushNamed('cashPayment', params: {
                  'tab': '2',
                  'total': '${widget.sum}',
                  'isNotProcessedOrder': widget.isNotProcessedOrder
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 250, left: 21, right: 21),
                width: MediaQuery.of(context).size.width,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: const Offset(1, 2), // Shadow position
                    ),
                  ],
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Espèces',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF010118),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 14),
                    width: 50,
                    child: const Icon(Ionicons.chevron_forward_outline),
                  )
                ]),
              )),
        ],
      ),
    );
  }
}
