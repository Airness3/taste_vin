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
    final tempMin = temperature['temp_min_c'];
final tempMax = temperature['temp_max_c'];

final tempMoyenne =
    (tempMin + tempMax) / 2;
    final position =
    ((tempMoyenne - 4) / (22 - 4))
        .clamp(0.0, 1.0);
final verre = wineProfile['verre'];
final carafage = wineProfile['carafage'];
final robe = wineProfile['robe'];
final robePosition = {
  'JAUNE_VERT': 0.00,
  'JAUNE_PALE': 0.09,
  'JAUNE_CITRON': 0.18,
  'JAUNE_OR': 0.27,
  'JAUNE_AMBRE': 0.36,
  'ROSE_PALE': 0.45,
  'ROSE_SOUTENU': 0.54,
  'ORANGE': 0.63,
  'ROUGE_RUBIS': 0.72,
  'ROUGE_GRENAT': 0.81,
  'ROUGE_POURPRE': 0.90,
  'ROUGE_TUILE': 1.00,
}[robe['code']] ?? 0.5;
final aromes = wineProfile['aromes'];
final bouche = wineProfile['bouche'];
final accords = wineProfile['accords'];
print(verre);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E),
        title: const Text(
          'Conseils du Sommelier',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
          children: [

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A3B31),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        '🍷 Conseils de dégustation',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 20),

      const Text(
  '🌡 Température de service',
  style: TextStyle(
    color: Colors.white70,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 16),

LayoutBuilder(
  builder: (context, constraints) {

    final cursorX =
        constraints.maxWidth * position;

    return SizedBox(
      height: 36,
      child: Stack(
        children: [

          Positioned.fill(
            top: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4FC3F7),
                    Color(0xFF66BB6A),
                    Color(0xFFFFB74D),
                    Color(0xFFE53935),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: cursorX - 10,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
),

const SizedBox(height: 12),

Center(
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      '${temperature['temp_min_c']}°C à ${temperature['temp_max_c']}°C',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

      const SizedBox(height: 12),

      Text(
        '🍾 ${carafage['type']['libelle']}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),

      const SizedBox(height: 12),

      Text(
        '🥂 ${verre['nom']}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    ],
  ),
),
),
            const SizedBox(height: 20),

            Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: const Color(0xFF1E1E1E),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          '🍇 Notes de dégustation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
  '👁 Robe',
  style: TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

LayoutBuilder(
  builder: (context, constraints) {

    final cursorX =
        constraints.maxWidth * robePosition;

    return SizedBox(
      height: 40,
      child: Stack(
        children: [

          Positioned.fill(
            top: 14,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD9F56D),
                    Color(0xFFF7F3A1),
                    Color(0xFFF4E04D),
                    Color(0xFFE4B429),
                    Color(0xFFC97A12),
                    Color(0xFFF7C8D8),
                    Color(0xFFEA7A9A),
                    Color(0xFFE38421),
                    Color(0xFFB11226),
                    Color(0xFF7A1D31),
                    Color(0xFF5B1331),
                    Color(0xFF8B4A3A),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: cursorX - 11,
            top: 3,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black45,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
),

const SizedBox(height: 12),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Color(
          int.parse(
            robe['couleur_hex']
                .replaceFirst('#', '0xFF'),
          ),
        ),
        shape: BoxShape.circle,
      ),
    ),

    const SizedBox(width: 10),

    Text(
      robe['libelle'],
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),

const SizedBox(height: 20), 

        const Text(
          "👃 Arômes",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (aromes as List)
              .map<Widget>(
                (a) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    a['libelle'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 24),

        const Text(
          "👄 Bouche",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (bouche as List)
              .map<Widget>(
                (b) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    b['libelle'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  ),
),


            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2017),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        '🍽 Accords mets-vins',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 20),

            ...(accords as List).map(
        (accord) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            accord['libelle'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),

    ],
  ),
),
            ),

          ],
        ),
      ),
    );
  }
}