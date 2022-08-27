import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../shared/app_colors.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool isBusy;
  double? width;
  final void Function()? onTap;
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
        decoration: BoxDecoration(
          color: kAppBarBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: !isBusy
              ? BoxText.body(
                  title,
                  color: Colors.white,
                )
              : const SpinKitWave(
                  color: Colors.white,
                  size: 20.0,
                ),
        ),
        width: (width == null) ? size.width - 110 : width,
        height: 55,
        duration: const Duration(
          milliseconds: 350,
        ),
      ),
    );
  }
}
