import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../shared/app_colors.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool isBusy;
  double? width;
  final void Function()? onTap;

  BoxButton.main({
    Key? key,
    required this.title,
    this.width,
    this.isBusy = false,
    this.onTap,
  }) : super(key: key);

  BoxButton.normal({
    Key? key,
    required this.title,
    this.width,
    this.isBusy = false,
    this.onTap,
  }) : super(key: key);

  BoxButton.changedColor({
    required this.title,
    this.isBusy = false,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: 58,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Center(
              child: !isBusy
                  ? BoxText.mainButtonText(
                      title.toUpperCase(),
                      color: Colors.white,
                    )
                  : const SpinKitWave(
                      color: Colors.white,
                      size: 20.0,
                    ),
            ),
            Positioned(
              right: 12.27,
              top: 14,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD051),
                  shape: BoxShape.circle,
                ),
                width: 30,
                height: 30,
                child: const Center(
                  child: Icon(
                    Ionicons.arrow_forward_outline,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
        duration: const Duration(
          milliseconds: 350,
        ),
      ),
    );
  }
}
