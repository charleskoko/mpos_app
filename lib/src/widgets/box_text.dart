// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mpos_app/src/shared/styles.dart';
import '../shared/app_colors.dart';

class BoxText extends StatelessWidget {
  final String text;
  final TextStyle style;

  BoxText.appBarTitle(this.text, {Color color = kPrimaryColor})
      : style = appBarTileStyle.copyWith(
          color: color,
        );

  BoxText.mainButtonText(this.text, {Color color = kPrimaryColor})
      : style = mainButtonTextStyle.copyWith(
          color: color,
        );

  BoxText.headingOne(this.text, {Color color = kblackColor})
      : style = appBarTileStyle.copyWith(
          color: color,
        );
  BoxText.headingTwo(this.text, {Color color = kblackColor})
      : style = appBarTileStyle.copyWith(
          color: color,
        );
  const BoxText.headingThree(this.text) : style = heading3Style;
  const BoxText.headline(this.text) : style = headlineStyle;
  BoxText.subheading(
    this.text, {
    Color color = kblackColor,
    FontWeight fontWeight = FontWeight.normal,
  }) : style = subheadingStyle.copyWith(
          color: color,
          fontWeight: fontWeight,
        );
  BoxText.caption(this.text,
      {Color color = kblackColor,
      double fontSize = 14.0,
      FontWeight fontWeight = FontWeight.normal})
      : style = captionStyle.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );

  BoxText.body(
    this.text, {
    Color color = kblackColor,
    FontWeight fontWeight = FontWeight.normal,
  }) : style = bodyStyle.copyWith(
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
