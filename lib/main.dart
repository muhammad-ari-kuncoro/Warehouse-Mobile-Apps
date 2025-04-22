import 'package:flutter/material.dart';
import 'package:mobile_apps_wh/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_apps_wh/dashboard/indexDashboard.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await _loadTheme(); // Load theme sebelum runApp
  runApp(const MyApp());
}

// Fungsi untuk memuat tema dari shared_preferences
Future<void> _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
}

// Fungsi untuk menyimpan tema saat diubah
Future<void> _saveTheme(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
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
          home: LoginScreen(),
        );
      },
    );
  }
}
