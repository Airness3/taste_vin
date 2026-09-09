import 'package:flutter/material.dart';
import 'package:taste_vin/widgets/navigation_taste_vin.dart'; // ✔ ton widget navigation
import 'scan_camera_page.dart';
import 'cellar_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    ScanCameraPage(),
    CellarPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // crème Taste Vin
      body: _pages[_currentIndex],

      bottomNavigationBar: TasteVinNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Accueil Taste Vin",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A3D2E), // vert bouteille Taste Vin
        ),
      ),
    );
  }
}
