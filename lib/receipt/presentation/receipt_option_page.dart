import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/shared/app_colors.dart';

class ReceiptOptionPage extends StatefulWidget {
  final String orderId;
  const ReceiptOptionPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ReceiptOptionPage> createState() => _ReceiptOptionPageState();
}

class _ReceiptOptionPageState extends State<ReceiptOptionPage> {
  @override
  void initState() {
    print('here the page');
    super.initState();
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas de monnaie',
                    style: TextStyle(
                      fontFamily: 'Poppins-bold',
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'sur 1599 FCFA',
                    style: TextStyle(
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
                Navigator.pop(context);
                context.goNamed('sendReceiptByEmail',
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
