import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../shared/app_colors.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool isBusy;
  final void Function()? onTap;
  const BoxButton({
    Key? key,
    required this.title,
    this.isBusy = false,
    this.onTap,
  }) : super(key: key);

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
            gradient: const LinearGradient(
              colors: [
                kPrimaryColorGradient,
                kPrimaryColorDark,
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
