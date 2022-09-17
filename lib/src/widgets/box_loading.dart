import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mpos_app/src/shared/app_colors.dart';

class BoxLoading extends StatelessWidget {
  const BoxLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitWave(
        color: kPrimaryColor,
        size: 30.0,
      ),
    );
  }
}
