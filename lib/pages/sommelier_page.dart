import 'package:flutter/material.dart';

class SommelierPage extends StatelessWidget {
  const SommelierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Fond crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
        title: const Text(
          "Conseils du Sommelier",
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
              "Conseils personnalisés",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3D2E),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "• Température idéale : 12–14°C\n"
              "• Aération : 10 minutes avant service\n"
              "• Verre recommandé : Universel Taste Vin\n"
              "• Accord parfait : Fromages affinés ou volaille rôtie",
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Retour",
                  style: TextStyle(
                    fontSize: 18,
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
