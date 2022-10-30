import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/shared/app_colors.dart';

class ReceiptOptionPage extends StatefulWidget {
  final String orderId;
  final String sum;
  final String cash;
  const ReceiptOptionPage(
      {Key? key, required this.orderId, required this.sum, required this.cash})
      : super(key: key);

  @override
  State<ReceiptOptionPage> createState() => _ReceiptOptionPageState();
}

class _ReceiptOptionPageState extends State<ReceiptOptionPage> {
  double? total;
  double? cashPayed;

  @override
  void initState() {
    total = double.tryParse(widget.sum);
    cashPayed = double.tryParse(widget.cash);
    super.initState();
  }

  String change() {
    double? change = cashPayed! - total!;
    if (change == 0) {
      return 'Pas de monnaie';
    }
    return 'Rendre $change FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      body: Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              height: 60,
              child: TextButton(
                child: const Text(
                  'Nouvelle vente',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: kPrimaryColor,
                  ),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    change(),
                    style: const TextStyle(
                      fontFamily: 'Poppins-bold',
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'sur $cashPayed FCFA',
                    style: const TextStyle(
                      fontFamily: 'Poppins-light',
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 100),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Comment souhaitez-vous recevoir votre reçu?',
                style: TextStyle(
                  fontFamily: 'Poppins-light',
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.pushNamed('sendReceiptByEmail',
                    params: {'tab': '2', 'orderId': widget.orderId});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFF262262),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'E-mail',
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFF262262),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'Aucun reçu',
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
          ],
        ),
      ),
    );
  }
}
