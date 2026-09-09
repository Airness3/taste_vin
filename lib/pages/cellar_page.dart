import 'package:flutter/material.dart';

class CellarPage extends StatelessWidget {
const CellarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
        title: const Text(
          "Ma Cave",
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
              "Vos bouteilles",
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
                    leading: Icon(Icons.wine_bar, color: Color(0xFF0A3D2E)),
                    title: Text("Château Margaux 2015"),
                    subtitle: Text("2 bouteilles – Casier B"),
                  ),
                  ListTile(
                    leading: Icon(Icons.wine_bar, color: Color(0xFF0A3D2E)),
                    title: Text("Sancerre Blanc 2022"),
                    subtitle: Text("1 bouteille – Étagère 2"),
                  ),
                  ListTile(
                    leading: Icon(Icons.wine_bar, color: Color(0xFF0A3D2E)),
                    title: Text("Côte-Rôtie 2018"),
                    subtitle: Text("3 bouteilles – Casier A"),
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
