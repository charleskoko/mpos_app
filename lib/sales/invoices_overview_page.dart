import 'package:flutter/material.dart';

import '../src/shared/app_colors.dart';
import '../src/widgets/box_text.dart';

class InvoicesOverviewPage extends StatefulWidget {
  const InvoicesOverviewPage({Key? key}) : super(key: key);

  @override
  State<InvoicesOverviewPage> createState() => _InvoicesOverviewPageState();
}

class _InvoicesOverviewPageState extends State<InvoicesOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: BoxText.headingTwo(
          'Ventes'.toUpperCase(),
          color: kThreeColor,
        ),
      ),
    );
  }
}
