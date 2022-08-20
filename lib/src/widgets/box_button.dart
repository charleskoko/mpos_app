import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../shared/app_colors.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool isBusy;
  final void Function()? onTap;
  final Color primaryColor;
  final Color darkColor;
  BoxButton.normal({
    Key? key,
    required this.title,
    this.isBusy = false,
    this.onTap,
  })  : primaryColor = kPrimaryColorGradient,
        darkColor = kPrimaryColorDark,
        super(key: key);

  BoxButton.changedColor({
    required this.title,
    this.isBusy = false,
    this.onTap,
    required this.primaryColor,
    required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.5),
            offset: const Offset(0, 24),
            blurRadius: 50,
            spreadRadius: -18,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          child: Center(
            child: !isBusy
                ? BoxText.subheading(
                    title,
                    color: Colors.white,
                  )
                : const SpinKitWave(
                    color: Colors.white,
                    size: 20.0,
                  ),
          ),
          width: size.width - 110,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                primaryColor,
                darkColor,
              ],
            ),
          ),
          duration: const Duration(
            milliseconds: 350,
          ),
        ),
      ),
    );
  }
}
