import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/cart_screen.dart';
import '../widgets/bottom_nav_bar.dart';

/// AppShell hosts the main bottom-navigation experience.
/// Manages the Home / Menu / Cart tabs.
class AppShell extends StatefulWidget {
  final String serviceType; // 'Dine-In' or 'Take-Out'
  const AppShell({super.key, required this.serviceType});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Screens for each nav tab
  final List<Widget> _screens = const [
    HomeScreen(),
    MenuScreen(),
    CartScreen(),
  ];

  void _onNavTap(int index) {
    if (index == 2) {
      // Navigate to Cart as a full route for Back button support
      Navigator.of(context).pushNamed('/cart');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/menu');
    } else {
      setState(() => _currentIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BenzBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
