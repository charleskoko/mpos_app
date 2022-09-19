import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/shared/styles.dart';
import '../../src/shared/app_colors.dart';
import '../dashboard/presentation/dashboard_page.dart';
import '../orders/presentation/not_processed_order_page.dart';
import '../orders/presentation/orders_overview_page.dart';
import '../products/presentation/products_overview_page.dart';
import '../sales/presentation/sales_overview_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        unselectedItemColor: const Color(0xFFB8B8B8),
        selectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
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
        onTap: _selectScreen,
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
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 19, bottom: 12.11),
              child: Icon(Ionicons.receipt_outline, size: 30),
            ),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 19, bottom: 12.11),
              child: Icon(Ionicons.settings_outline, size: 30),
            ),
            label: 'Paramètres',
          ),
        ],
      ),
      body: [
        const DashboardPage(),
        const OrdersOverviewPage(),
        const NotProcessedOrderPage(),
        const SalesOverviewPage(),
      ].elementAt(_selectedScreenIndex),
    );
  }
}
