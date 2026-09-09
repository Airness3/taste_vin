import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Taste Vin
            Image.asset(
              'assets/icons/icone_appli_clean.png',
              width: 140,
              height: 140,
            ),

            const SizedBox(height: 40),

            // Bouton Connexion
            SizedBox(
              width: 200,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                child: const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
