import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../products/core/domaine/product.dart';

class BoxProduct extends StatelessWidget {
  final Product product;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const BoxProduct({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
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
              right: 0,
              child: InkWell(
                onTap: onDelete,
                child: const Icon(
                  Ionicons.close_circle_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              left: 0,
              child: InkWell(
                onTap: onEdit,
                child: const Icon(
                  Ionicons.pencil_outline,
                  size: 17,
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 10,
              child: BoxText.body('${product.label}'),
            ),
            Positioned(
              bottom: 5,
              left: 10,
              child: BoxText.body(
                '${product.price} XOF',
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
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
