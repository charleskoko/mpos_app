// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mpos_app/src/shared/styles.dart';
import '../shared/app_colors.dart';

class BoxText extends StatelessWidget {
  final String text;
  final TextStyle style;

  BoxText.headingOne(this.text, {Color color = kblackColor})
      : style = heading1Style.copyWith(color: color);
  BoxText.headingTwo(this.text, {Color color = kblackColor})
      : style = heading2Style.copyWith(color: color);
  const BoxText.headingThree(this.text) : style = heading3Style;
  const BoxText.headline(this.text) : style = headlineStyle;
  BoxText.subheading(this.text, {Color color = kblackColor})
      : style = subheadingStyle.copyWith(color: color);
  BoxText.caption(this.text, {Color color = kblackColor})
      : style = captionStyle.copyWith(color: color);

  BoxText.body(this.text,
      {Color color = kblackColor, FontWeight fontWeight = FontWeight.normal})
      : style = bodyStyle.copyWith(
          color: color,
          fontWeight: fontWeight,
        );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
