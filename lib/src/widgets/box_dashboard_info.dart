// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

class BoxDashboardInfo extends StatelessWidget {
  final Color backgroundColor;
  final IconData illustrateIcon;
  final Color illustrateBackgroundColor;
  final String label;
  final bool withCurrency;
  final String? data;

  const BoxDashboardInfo.salesDetails({required this.data})
      : backgroundColor = const Color(0xffF4E9F3),
        illustrateIcon = Ionicons.receipt_outline,
        illustrateBackgroundColor = const Color(0xFFE9DFE8),
        withCurrency = false,
        label = 'Ventes';

  const BoxDashboardInfo.salesTotal({required this.data})
      : backgroundColor = const Color(0xFFF6E8EA),
        illustrateIcon = Ionicons.cash_outline,
        illustrateBackgroundColor = const Color(0xFFE8DDDF),
        withCurrency = true,
        label = 'Recette';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: illustrateBackgroundColor,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              height: 60,
              width: 60,
              child: Center(
                child: Icon(illustrateIcon),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: BoxText.subheading(
              label,
              color: Colors.grey.shade500,
            ),
          ),
          Positioned(
            bottom: 5,
            child: Row(
              children: [
                if (withCurrency)
                  BoxText.caption(
                    'FCFA',
                    color: Colors.grey.shade500,
                  ),
                const SizedBox(height: 5),
                BoxText.headingThree(
                  '$data',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
