import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../src/shared/app_colors.dart';
import '../dashboard/presentation/dashboard_page.dart';
import '../orders/presentation/orders_overview_page.dart';
import '../products/presentation/products_overview_page.dart';
import '../settings/presentation/settings_page.dart';

class MainPage extends StatefulWidget {
  final int tab;
  const MainPage({Key? key, this.tab = 0}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (selectedMenuItem) {
          context.goNamed('main', params: {'tab': '$selectedMenuItem'});
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        unselectedItemColor: const Color(0xFFB8B8B8),
        selectedItemColor: Colors.white,
        currentIndex: widget.tab,
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w400,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w700,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 19, bottom: 12.11),
              child: Icon(Ionicons.pie_chart_outline, size: 30),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 19, bottom: 12.11),
              child: Icon(Ionicons.reader_outline, size: 30),
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(top: 19, bottom: 12.11),
                child: Icon(Ionicons.receipt_outline, size: 30)),
            label: 'Caisse',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(top: 19, bottom: 12.11),
                child: Icon(Ionicons.settings_outline, size: 30)),
            label: 'Paramètres',
          ),
        ],
      ),
      body: [
        const DashboardPage(),
        const OrdersOverviewPage(),
        const ProductsOverviewPage(),
        const SettingsPage(),
      ].elementAt(widget.tab),
    );
  }
}
