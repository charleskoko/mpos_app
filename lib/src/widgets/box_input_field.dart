// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../shared/app_colors.dart';
import '../shared/styles.dart';

class BoxInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final String? Function(String value)? validator;
  final String? Function(String value)? onChanged;
  final bool isPasswordTextField;
  final TextInputType? textInputType;

  BoxInputField.text({
    this.controller,
    this.labelText,
    this.icon,
    this.hintText,
    this.onChanged,
    this.validator,
  })  : isPasswordTextField = false,
        textInputType = TextInputType.text;

  BoxInputField.password({
    this.controller,
    this.labelText,
    this.icon,
    this.hintText,
    this.onChanged,
    this.validator,
  })  : isPasswordTextField = true,
        textInputType = TextInputType.text;

  BoxInputField.email({
    this.controller,
    this.labelText,
    this.icon,
    this.hintText,
    this.onChanged,
    this.validator,
  })  : isPasswordTextField = false,
        textInputType = TextInputType.emailAddress;

  BoxInputField.number({
    this.controller,
    this.labelText,
    this.icon,
    this.hintText,
    this.onChanged,
    this.validator,
  })  : isPasswordTextField = false,
        textInputType = TextInputType.number;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      cursorColor: kPrimaryColor,
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPasswordTextField,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: bodyStyle.copyWith(
          color: Colors.grey.shade600,
        ),
        hintText: hintText,
        hintStyle: subheadingStyle,
        prefixIcon: (icon == null)
            ? null
            : Icon(
                icon,
                color: kPrimaryColor,
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) => validator!(value!),
      onChanged: (value) => onChanged!(value),
    );
  }
}
