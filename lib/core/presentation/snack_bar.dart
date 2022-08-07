import 'package:flutter/material.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../src/shared/app_colors.dart';

buidSnackbar({
  required BuildContext context,
  Color backgroundColor = kblackColor,
  required String text,
}) {
  SnackBar snackBar = SnackBar(
    backgroundColor: backgroundColor,
    content: BoxText.body(
      text,
      color: Colors.white,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
