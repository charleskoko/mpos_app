import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../products/core/domaine/product.dart';
import '../shared/app_colors.dart';

class BoxProduct extends StatelessWidget {
  final Product product;

  const BoxProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 4,
        top: 4,
        right: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Stack(
        children: [
          Container(
            alignment: const Alignment(0, 0),
            child: BoxText.subheading(
              '${product.label}',
              fontWeight: FontWeight.bold,
              color: kProductInfoColor,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 10,
            child: BoxText.caption(
              '${product.price} FCFA',
              fontSize: 15,
              color: kProductInfoColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
