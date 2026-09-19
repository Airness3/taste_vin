import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  final String ocrText;
  final int couleurId;

  const ScanResultPage({
    super.key,
    required this.ocrText,
    required this.couleurId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E),
        title: const Text(
          "Résultat du scan",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "🍷 Fiche TasteVin",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A3D2E),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Texte OCR détecté",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),

                child: Text(
                  ocrText,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Couleur sélectionnée : $couleurId",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.restaurant),
                  label: const Text(
                    "Voir les conseils du sommelier",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.wine_bar),
                  label: const Text(
                    "Ajouter à ma cave",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  label: const Text(
                    "Ajouter aux favoris",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.star),
                  label: const Text(
                    "Noter ce vin",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}