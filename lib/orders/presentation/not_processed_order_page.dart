import 'package:flutter/material.dart';

import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_text.dart';

class NotProcessedOrderPage extends StatefulWidget {
  const NotProcessedOrderPage({Key? key}) : super(key: key);

  @override
  State<NotProcessedOrderPage> createState() => _NotProcessedOrderPageState();
}

class _NotProcessedOrderPageState extends State<NotProcessedOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.grey.shade100,
      centerTitle: true,
      elevation: 0,
      title: BoxText.headingTwo(
        'Sauvegardes'.toUpperCase(),
        color: kThreeColor,
      ),
    ));
  }
}
