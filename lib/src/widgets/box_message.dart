import 'package:flutter/material.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

class BoxMessage extends StatelessWidget {
  final String? message;

  const BoxMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$message',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
