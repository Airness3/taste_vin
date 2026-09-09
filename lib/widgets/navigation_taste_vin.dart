import 'package:flutter/material.dart';

class TasteVinNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TasteVinNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
      selectedItemColor: const Color(0xFFD9A441), // Doré Taste Vin
      unselectedItemColor: const Color(0xFFC0C0C0), // Argent Taste Vin
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Accueil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: "Scan",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wine_bar),
          label: "Cave",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}
