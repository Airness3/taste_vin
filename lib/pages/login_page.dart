import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7A1), // Fond crème TasteVin
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo TasteVin PRO
            Image.asset(
              'assets/images/icone_profil.png', // Mets ton vrai logo ici
              width: 160,
            ),

            const SizedBox(height: 40),

            // Titre premium
            Text(
              "TasteVin",
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A3D2E), // Vert bouteille
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Découvrez, dégustez, partagez",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: const Color(0xFF5A0F1A), // Bordeaux
              ),
            ),

            const SizedBox(height: 50),

            // Bouton Connexion TasteVin PRO
            SizedBox(
              width: 220,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC0C0C0), // Métal argent
                  foregroundColor: const Color(0xFF0A3D2E), // Vert bouteille
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                child: const Text(
                  "Entrer dans la cave",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton secondaire (Découvrir)
            SizedBox(
              width: 220,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD45A1F), // Ambre / orange
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                child: const Text(
                  "Découvrir",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
