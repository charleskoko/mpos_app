import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/shared/styles.dart';
import '../../src/shared/app_colors.dart';
import '../dashboard/presentation/dashboard_page.dart';
import '../orders/presentation/not_processed_order_page.dart';
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
        elevation: 0,
        unselectedItemColor: kSecondaryColor,
        selectedItemColor: kThreeColor,
        currentIndex: _selectedScreenIndex,
        selectedLabelStyle: captionStyle,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.storefront_outline),
            label: 'Boutique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.briefcase_outline),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.file_tray_full_outline),
            label: 'Sauvegardes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.albums_outline),
            label: 'Reçus',
          ),
        ],
      ),
      body: [
        const DashboardPage(),
        const ProductsOverviewPage(),
        const NotProcessedOrderPage(),
        const SalesOverviewPage(),
      ].elementAt(_selectedScreenIndex),
    );
  }
}
