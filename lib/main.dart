import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pages Taste Vin
import 'package:taste_vin/pages/splash_page.dart';
import 'package:taste_vin/pages/login_page.dart';
import 'package:taste_vin/pages/home_page.dart';
import 'package:taste_vin/pages/scan_camera_page.dart';
import 'package:taste_vin/pages/scan_result_page.dart';
import 'package:taste_vin/pages/sommelier_page.dart';
import 'package:taste_vin/pages/cellar_page.dart';
import 'package:taste_vin/pages/profile_page.dart';
import 'package:taste_vin/pages/favorites_page.dart';
import 'package:taste_vin/pages/history_page.dart';
import 'package:taste_vin/pages/improve_database_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://vgjytsszmhjxcqdwaskr.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZnanl0c3N6bWhqeGNxZHdhc2tyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU2MzUyMDEsImV4cCI6MjEwMTIxMTIwMX0.9dKSieLssfHXmeIyuO2OVpe98icePlBc8p01ipdfZOo",
  );

  runApp(TasteVinApp());
}

class TasteVinApp extends StatelessWidget {
  const TasteVinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Taste Vin",
      theme: tasteVinTheme,
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashPage(),
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/scan": (context) => ScanCameraPage(),
        "/scan_result": (context) => ScanResultPage(),
        "/sommelier": (context) => SommelierPage(),
        "/cellar": (context) => CellarPage(),
        "/profile": (context) => ProfilePage(),
        "/favorites": (context) => FavoritesPage(),
        "/history": (context) => HistoryPage(),
        "/improve_db": (context) => ImproveDatabasePage(),
      },
    );
  }
}

final ThemeData tasteVinTheme = ThemeData(
  // ton thème Taste Vin ici
);
