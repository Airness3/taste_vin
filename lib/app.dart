import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'pages/cellar_page.dart';
import 'pages/favorites_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/improve_database_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'pages/scan_camera_page.dart';
import 'pages/scan_result_page.dart';
import 'pages/sommelier_page.dart';
import 'pages/splash_page.dart';

class TasteVinApp extends StatelessWidget {
  const TasteVinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TasteVin',
      debugShowCheckedModeBanner: false,
      theme: TasteVinTheme.theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/scan_camera': (context) => const ScanCameraPage(),
        '/scan_result': (context) => const Scaffold(
  body: Center(
    child: Text('ScanResultPage appelée sans OCR'),
  ),
),
        '/cellar': (context) => const CellarPage(),
        '/profile': (context) => const ProfilePage(),
        '/favorites': (context) => const FavoritesPage(),
        '/history': (context) => const HistoryPage(),
        '/sommelier': (context) => const SommelierPage(),
        '/improve_database': (context) => const ImproveDatabasePage(),
      },
    );
  }
}
