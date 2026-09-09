import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
        title: const Text(
          "Historique des scans",
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
              "Vos derniers scans",
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
                    leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                    title: Text("Bourgogne 2020"),
                    subtitle: Text("Scanné le 03/09/2026"),
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                    title: Text("Champagne Brut"),
                    subtitle: Text("Scanné le 01/09/2026"),
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                    title: Text("Bordeaux 2018"),
                    subtitle: Text("Scanné le 29/08/2026"),
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
