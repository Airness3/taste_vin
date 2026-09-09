import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
        title: const Text(
          "Favoris",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vos vins favoris",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D2E),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                    title: Text("Château Margaux 2015"),
                    subtitle: Text("Rouge – Bordeaux"),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                    title: Text("Sancerre Blanc 2022"),
                    subtitle: Text("Blanc – Loire"),
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                    title: Text("Côte-Rôtie 2018"),
                    subtitle: Text("Rouge – Rhône"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
