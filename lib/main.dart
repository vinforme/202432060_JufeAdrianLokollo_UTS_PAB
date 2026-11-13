// Lokasi file: lib/main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const LostAndFoundApp());
}

class LostAndFoundApp extends StatelessWidget {
  const LostAndFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    const hijauTua = Color(0xFF1B5E20);
    const mint = Color(0xFFF1F8F1);
    return MaterialApp(
      title: 'Lost and Found Kampus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: hijauTua, brightness: Brightness.light, primary: hijauTua),
        useMaterial3: true,
        scaffoldBackgroundColor: mint,
        appBarTheme: const AppBarTheme(
          backgroundColor: mint,
          foregroundColor: Colors.black87,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 24, color: Colors.black87),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: hijauTua,
          unselectedLabelColor: Colors.black87,
          indicatorColor: hijauTua,
          dividerColor: Color(0xFFCFD8CF),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFE6EFE6),
          indicatorColor: const Color(0xFFA5F0A8),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
      home: const HomePage(),
    );
  }
}