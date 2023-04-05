import 'package:flutter/material.dart';
import 'package:flutter_mmh/screens/pages/myapp.dart';
import '../../services/theme_button.dart';

import '../../components/bot_navbar.dart';
import '../../components/menu_page.dart';
import '../pages/settings_page.dart';
import 'dashboard.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    // app page
    MapSample(),

    // profile page
    Dashboard(),

    // setting page
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        actions: [
          ChangeThemeButtonWidget(),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'M E E T   M E  H A L F W A Y',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: MenuPage(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
