import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Mon compte",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D2E),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF0A3D2E)),
              title: const Text("Modifier mon pseudo"),
              onTap: () {
                // TODO: page de modification
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF0A3D2E)),
              title: const Text("Déconnexion"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Favoris (aperçu)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D2E),
              ),
            ),

            const SizedBox(height: 10),

            // Aperçu des favoris (exemple)
            Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                  title: Text("Château Margaux 2015"),
                ),
                ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                  title: Text("Sancerre Blanc 2022"),
                ),
                ListTile(
                  leading: Icon(Icons.favorite, color: Color(0xFF0A3D2E)),
                  title: Text("Côte-Rôtie 2018"),
                ),
              ],
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/favorites"),
              child: const Text(
                "Voir tous mes favoris",
                style: TextStyle(
                  color: Color(0xFF0A3D2E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Historique des scans (aperçu)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D2E),
              ),
            ),

            const SizedBox(height: 10),

            Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                  title: Text("Scan : Bourgogne 2020"),
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                  title: Text("Scan : Champagne Brut"),
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Color(0xFF0A3D2E)),
                  title: Text("Scan : Bordeaux 2018"),
                ),
              ],
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/history"),
              child: const Text(
                "Voir tout mon historique",
                style: TextStyle(
                  color: Color(0xFF0A3D2E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
