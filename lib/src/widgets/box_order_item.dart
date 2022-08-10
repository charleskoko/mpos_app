import 'package:flutter/material.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

class BoxOrderItem extends StatelessWidget {
  final String productLabel;
  final String price;
  final String amount;
  final String total;

  const BoxOrderItem({
    Key? key,
    required this.productLabel,
    required this.price,
    required this.amount,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BoxText.body(
        productLabel,
        fontWeight: FontWeight.bold,
      ),
      subtitle: BoxText.body(
        '$price XOF x $amount',
        color: Colors.grey.shade600,
      ),
      trailing: BoxText.body(
        '$total XOF',
        color: Colors.grey.shade600,
      ),
    );
  }
}
