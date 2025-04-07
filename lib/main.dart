import 'package:flutter/material.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';
import 'package:mobile_apps_wh/menuProyek/indexProyek.dart';
import 'homePage.dart';
import 'dashboard/indexDashboard.dart';
import 'package:intl/date_symbol_data_local.dart';

final themeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light); // default: light
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Warehouse App',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F6FA),
            primarySwatch: Colors.blueGrey,
            drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            cardColor: Colors.white,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black87),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1C1C1E),
            primarySwatch: Colors.blueGrey,
            drawerTheme:
                const DrawerThemeData(backgroundColor: Color(0xFF2C2C2E)),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2C2C2E),
              foregroundColor: Colors.white,
            ),
            cardColor: const Color(0xFF2C2C2E),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          home: const DashboardScreen(),
        );
      },
    );
  }
}
