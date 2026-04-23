import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/app_shell.dart';
import 'screens/menu_screen.dart';
import 'screens/customize_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/receipt_screen.dart';
import 'theme/app_theme.dart';

// Add this at the top of main.dart after imports
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// TODO: Staff app for inventory & order management (Part 2)

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for kiosk use (change to landscape for wide kiosks)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Full-screen / immersive for kiosk experience
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const BenzCoffeeApp());
}

// Add this class anywhere in main.dart
class SnackBarNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Hide snackbar when pushing new route
    rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Hide snackbar when popping route
    rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    super.didPop(route, previousRoute);
  }
}

class BenzCoffeeApp extends StatelessWidget {
  const BenzCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cart state – persists across all screens
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Benz Coffee',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        scaffoldMessengerKey: rootScaffoldMessengerKey, // Add this
        navigatorObservers: [SnackBarNavigatorObserver()], // Add this

        // ── Named Routes ─────────────────────────────────────────
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const WelcomeScreen(),
                settings: settings,
              );

            case '/home':
              final serviceType = settings.arguments as String? ?? 'Dine-In';
              return MaterialPageRoute(
                builder: (_) => AppShell(serviceType: serviceType),
                settings: settings,
              );

            case '/menu':
              // Accepts optional String argument for initial category
              return MaterialPageRoute(
                builder: (_) => const MenuScreen(),
                settings: settings,
              );

            case '/customize':
              // Requires MenuItem argument
              return MaterialPageRoute(
                builder: (_) => const CustomizeScreen(),
                settings: settings,
                fullscreenDialog: true,
              );

            case '/cart':
              return MaterialPageRoute(
                builder: (_) => const CartScreen(),
                settings: settings,
              );

            case '/receipt':
              // Requires Map<String, dynamic> argument with orderNumber, items, total
              return MaterialPageRoute(
                builder: (_) => const ReceiptScreen(),
                settings: settings,
              );

            default:
              // Fallback to welcome screen
              return MaterialPageRoute(
                builder: (_) => const WelcomeScreen(),
              );
          }
        },
      ),
    );
  }
}
