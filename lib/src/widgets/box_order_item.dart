import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../orders/core/domain/selected_order_item.dart';

class BoxOrderItem extends StatefulWidget {
  SelectedOrderItem selectedOrderItem;
  final bool isOrderVerification;
  final void Function()? onRemove;
  final void Function()? onAdd;

  BoxOrderItem({
    Key? key,
    required this.selectedOrderItem,
    this.onRemove,
    this.isOrderVerification = true,
    this.onAdd,
  }) : super(key: key);

  @override
  State<BoxOrderItem> createState() => _BoxOrderItemState();
}

class _BoxOrderItemState extends State<BoxOrderItem> {
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
                    widget.selectedOrderItem.product?.label ?? '',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      if (widget.isOrderVerification)
                        InkWell(
                          onTap: widget.onRemove,
                          child: Icon(
                            Ionicons.remove_circle_outline,
                            size: 32,
                            color: Colors.red.shade400,
                          ),
                        ),
                      const SizedBox(width: 5),
                      Center(
                        child: BoxText.body(
                          '${widget.selectedOrderItem.amount ?? 0}',
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.isOrderVerification)
                        InkWell(
                          onTap: widget.onAdd,
                          child: Icon(
                            Ionicons.add_circle_outline,
                            size: 32,
                            color: Colors.green.shade400,
                          ),
                        ),
                      BoxText.body(
                        ' x ${widget.selectedOrderItem.price} XOF',
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
              '${widget.selectedOrderItem.price! * widget.selectedOrderItem.amount!} XOF',
              color: Colors.grey.shade900,
            ),
          )
        ],
      ),
    );
  }
}
