import 'package:flutter/material.dart';

import '../src/shared/app_colors.dart';
import '../src/widgets/box_text.dart';

class SalesOverviewPage extends StatefulWidget {
  SalesOverviewPage({Key? key}) : super(key: key);

  @override
  State<SalesOverviewPage> createState() => _SalesOverviewPage();
}

class _SalesOverviewPage extends State<SalesOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: BoxText.headingTwo(
          'Ventes'.toUpperCase(),
          color: kThreeColor,
        ),
        actions: [],
      ),
    );
    ;
  }
}
