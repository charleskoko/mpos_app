import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

class BoxOrderItem extends StatelessWidget {
  final String productLabel;
  final String price;
  final String amount;
  final String total;
  final bool isOrderVerification;
  final void Function()? onRemove;
  final void Function()? onAdd;

  const BoxOrderItem({
    Key? key,
    required this.productLabel,
    required this.price,
    required this.amount,
    required this.total,
    this.onRemove,
    this.isOrderVerification = true,
    this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: BoxText.body(
                    productLabel,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      if (isOrderVerification)
                        InkWell(
                          onTap: onRemove,
                          child: Icon(
                            Ionicons.remove_circle_outline,
                            size: 32,
                            color: Colors.red.shade400,
                          ),
                        ),
                      const SizedBox(width: 5),
                      Center(
                        child: BoxText.body(
                          amount,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (isOrderVerification)
                        InkWell(
                          onTap: onAdd,
                          child: Icon(
                            Ionicons.add_circle_outline,
                            size: 32,
                            color: Colors.green.shade400,
                          ),
                        ),
                      BoxText.body(
                        ' x $price XOF',
                        color: Colors.grey.shade900,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: BoxText.body(
              '$total XOF',
              color: Colors.grey.shade900,
            ),
          )
        ],
      ),
    );
  }
}
