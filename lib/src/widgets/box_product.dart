import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../products/core/domaine/product.dart';

class BoxProduct extends StatelessWidget {
  final Product product;

  const BoxProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 28,
              left: 10,
              child: BoxText.body('${product.label}'),
            ),
            Positioned(
              bottom: 5,
              left: 10,
              child: BoxText.body(
                '${product.price} FCFA',
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 50,
                ),
                child: const Center(
                  child: Image(
                      image:
                          AssetImage("assets/images/image_placeholder.jpeg")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
