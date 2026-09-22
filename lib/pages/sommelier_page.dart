import 'package:flutter/material.dart';

class SommelierPage extends StatelessWidget {
  final Map<String, dynamic> wineProfile;

  const SommelierPage({
    super.key,
    required this.wineProfile,
  });

  @override
  Widget build(BuildContext context) {
    final temperature = wineProfile['temperature'];
    final verre = wineProfile['verre'];
    final carafage = wineProfile['carafage'];
    final robe = wineProfile['robe'];
    final aromes = wineProfile['aromes'];
    final bouche = wineProfile['bouche'];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E),
        title: const Text(
          "Conseils du Sommelier",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3B31),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "🍷 Conseils de dégustation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "🌡 Température de service",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "${temperature['temp_min_c']}°C à ${temperature['temp_max_c']}°C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                temperature['libelle'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                temperature['description'],
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(color: Colors.white24),

              const SizedBox(height: 20),

              const Text(
                "🍾 Carafage",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                carafage['type']['libelle'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "${carafage['regle']['duree_minutes']} minutes",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                carafage['regle']['commentaire'],
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(color: Colors.white24),

              const SizedBox(height: 20),

              const Text(
                "🥂 Verre recommandé",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                verre['nom'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                verre['description'],
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(color: Colors.white24),

              const SizedBox(height: 20),

              const Text(
                "👁 Robe",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                robe == null
                    ? "Robe non disponible"
                    : robe['libelle'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

const Divider(
  color: Colors.white24,
),

const SizedBox(height: 20),

const Text(
  "👃 Arômes",
  style: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Text(
  aromes.toString(),
  style: const TextStyle(
    color: Colors.white,
  ),
),

const SizedBox(height: 30),

const Divider(
  color: Colors.white24,
),

const SizedBox(height: 20),

const Text(
  "👄 Bouche",
  style: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Text(
  bouche.toString(),
  style: const TextStyle(
    color: Colors.white,
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}