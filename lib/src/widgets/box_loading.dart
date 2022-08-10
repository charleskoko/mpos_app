import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BoxLoading extends StatelessWidget {
  const BoxLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Colors.grey.shade300,
        size: 30.0,
      ),
    );
  }
}