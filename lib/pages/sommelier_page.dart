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
String getAromeEmoji(String code) {
  switch (code) {

    // FRUITS

    case 'CITRON': return '🍋';
    case 'PAMPLEMOUSSE': return '🍊';
    case 'ORANGE': return '🍊';
    case 'MANDARINE': return '🍊';

    case 'POIRE': return '🍐';
    case 'POMME_VERTE': return '🍏';

    case 'PECHE': return '🍑';
    case 'ABRICOT': return '🍑';

    case 'ANANAS': return '🍍';
    case 'MANGUE': return '🥭';

    case 'LITCHI': return '🌺';

    case 'FRAISE': return '🍓';
    case 'FRAMBOISE': return '🍓';

    case 'GROSEILLE': return '🔴';

    case 'CERISE': return '🍒';

    case 'CASSIS': return '🫐';
    case 'MYRTILLE': return '🫐';
    case 'MURE': return '🫐';

    case 'PRUNE': return '🟣';
    case 'FIGUE': return '🟣';

    case 'RAISIN_SEC': return '🍇';

    // FLORAL

    case 'ROSE': return '🌹';
    case 'VIOLETTE': return '🪻';
    case 'ACACIA': return '🌼';
    case 'AUBEPINE': return '🌸';
    case 'JASMIN': return '🌼';
    case 'LAVANDE': return '🪻';
    case 'TILLEUL': return '🍃';
    case 'PIVOINE': return '🌸';
    case 'FLEUR_BLANCHE': return '🤍';

    // VEGETAL

    case 'HERBE_COUPEE': return '🌿';
    case 'FOUGERE': return '🌿';
    case 'MENTHE': return '🌱';
    case 'EUCALYPTUS': return '🌿';
    case 'POIVRON': return '🫑';
    case 'THE': return '🍵';
    case 'FEUILLE_CASSIS': return '🍃';
    case 'FOIN': return '🌾';

    // EPICES

    case 'POIVRE_NOIR': return '⚫';
    case 'POIVRE_BLANC': return '⚪';
    case 'CANNELLE': return '🪵';
    case 'VANILLE': return '🌿';
    case 'REGLISSE': return '🖤';
    case 'CLOU_GIROFLE': return '🌰';
    case 'MUSCADE': return '🌰';
    case 'SAFRAN': return '🟠';

    // BOISE

    case 'CEDRE': return '🌲';
    case 'CHENE': return '🌳';
    case 'BOIS_TOASTE': return '🪵';
    case 'BOIS_FUME': return '🔥';
    case 'SANTAL': return '🪵';

    // MINERAL

    case 'SILEX': return '🪨';
    case 'CRAIE': return '⚪';
    case 'PIERRE_FUSIL': return '🪨';
    case 'CALCAIRE': return '⛰️';
    case 'IODE': return '🌊';

    // TORREFACTION

    case 'CAFE': return '☕';
    case 'CACAO': return '🍫';
    case 'CHOCOLAT': return '🍫';
    case 'MOKA': return '☕';
    case 'CARAMEL': return '🍮';

    // FUME

    case 'FUMEE': return '💨';
    case 'TABAC': return '🍂';
    case 'CUIR': return '🧥';
    case 'GOUDRON': return '⬛';
    case 'GRAPHITE': return '✏️';

    // ANIMAL

    case 'MUSC': return '🦌';
    case 'VENAISON': return '🦌';
    case 'CIRE': return '🕯️';
    case 'ETABLE': return '🐴';

    // RESINEUX

    case 'PIN': return '🌲';
    case 'RESINE': return '🌲';
    case 'GENEVRIER': return '🌿';
    case 'BAUME': return '🧴';

    // EVOLUTION

    case 'SOUS_BOIS': return '🍂';
    case 'CHAMPIGNON': return '🍄';
    case 'TRUFFE': return '🍄';
    case 'NOIX': return '🥜';
    case ' NOISETTE': return '🌰';
    case 'MIEL': return '🍯';
    case 'PAIN_GRILLE': return '🍞';
    case 'BEURRE': return '🧈';

    default:
      return '🍷';
  }
}
Color getAromeColor(int familleId) {
  switch (familleId) {

    case 1:
      return const Color(0xFF6A1B9A); // Fruits

    case 2:
      return const Color(0xFFE91E63); // Floral

    case 3:
      return const Color(0xFF2E7D32); // Végétal

    case 4:
      return const Color(0xFFEF6C00); // Épices

    case 5:
      return const Color(0xFF6D4C41); // Boisé

    case 6:
      return const Color(0xFF546E7A); // Minéral

    case 7:
      return const Color(0xFF4E342E); // Torréfaction

    case 8:
      return const Color(0xFF263238); // Fumé

    case 9:
      return const Color(0xFF8E0000); // Animal

    case 10:
      return const Color(0xFF1B5E20); // Résineux

    case 11:
      return const Color(0xFFB8860B); // Évolution

    default:
      return const Color(0xFF444444);
  }
}
Widget _legendChip(
  String label,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}
String getBoucheEmoji(String code) {
  switch (code) {
    case 'VIF':
      return '⚡';

    case 'FRAIS':
      return '❄️';

    case 'ROND':
      return '🟠';

    case 'SOUPLE':
      return '🪶';

    case 'GRAS':
      return '🧈';

    case 'MINERAL':
      return '🪨';

    case 'PUISSANT':
      return '💪';

    case 'TANNIQUE':
      return '🍇';

    case 'STRUCTURE':
      return '🏛️';

    case 'LONG':
      return '⏳';

    case 'EQUILIBRE':
      return '⚖️';

    case 'PERSISTANT':
      return '✨';

    default:
      return '🍷';
  }
}
String getMetEmoji(String code) {
  switch (code) {

    case 'APERITIF_CANAPES': return '🥂';
    case 'TAPAS': return '🍢';
    case 'CHARCUTERIE': return '🥓';

    case 'TERRINE': return '🍖';
    case 'FOIE_GRAS': return '🦆';
    case 'SALADE_LEGERE': return '🥗';
    case 'SALADE_CHEVRE': return '🥗';
    case 'QUICHE': return '🥧';
    case 'SOUPE_LEGUMES': return '🍵';

    case 'HUITRES': return '🦪';
    case 'COQUILLAGES': return '🐚';
    case 'CRUSTACES': return '🦞';
    case 'SAINT_JACQUES': return '🐚';

    case 'SUSHIS': return '🍣';
    case 'POISSON_BLANC': return '🐟';
    case 'POISSON_GRILLE': return '🔥';
    case 'SAUMON': return '🐟';
    case 'THON': return '🐟';
    case 'BOUILLABAISSE': return '🍲';

    case 'VOLAILLE_ROTIE': return '🍗';
    case 'VEAU': return '🥩';
    case 'PORC': return '🥓';
    case 'CANARD': return '🦆';

    case 'BOEUF_GRILLE': return '🥩';
    case 'BOEUF_MIJOTE': return '🍲';
    case 'AGNEAU': return '🐑';
    case 'GIBIER': return '🦌';
    case 'PLAT_SAUCE_ROUGE': return '🍲';
    case 'BARBECUE': return '🔥';

    case 'PIZZA_TOMATE': return '🍕';
    case 'PATES_TOMATE': return '🍝';
    case 'PATES_CREME': return '🍝';
    case 'RISOTTO': return '🍚';

    case 'CURRY_DOUX': return '🍛';
    case 'CURRY_EPICE': return '🌶️';

    case 'CUISINE_ASIATIQUE': return '🥢';
    case 'COUSCOUS': return '🍲';
    case 'CASSOULET': return '🍲';

    case 'PLAT_VEGETARIEN': return '🥦';
    case 'LEGUMES_GRILLES': return '🥕';
    case 'CHAMPIGNONS': return '🍄';
    case 'ASPERGES': return '🌱';

    case 'FROMAGE_FRAIS': return '🧀';
    case 'CHEVRE': return '🐐';
    case 'PATE_MOLLE': return '🧀';
    case 'PATE_PRESSEE': return '🧀';
    case 'PERSILLE': return '🧀';
    case 'PLATEAU_FROMAGES': return '🧀';

    case 'DESSERT_FRUITS': return '🍓';
    case 'TARTE_FRUITS': return '🥧';
    case 'DESSERT_CHOCOLAT': return '🍫';
    case 'DESSERT_CARAMEL': return '🍮';
    case 'DESSERT_CREME': return '🍰';
    case 'FRUITS_FRAIS': return '🍎';

    case 'BRUNCH': return '🍳';

    default:
      return '🍽️';
  }
}
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

      Center(
  child: Image.asset(
    verre['image_url'],
    height: 130,
    fit: BoxFit.contain,
  ),
),

const SizedBox(height: 12),

Center(
  child: Text(
    verre['nom'],
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 8),

Text(
  verre['description'],
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white70,
    fontSize: 14,
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
  borderRadius: BorderRadius.circular(24),

  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF252525),
      Color(0xFF151515),
    ],
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
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
          Theme(
  data: Theme.of(context).copyWith(
    dividerColor: Colors.transparent,
  ),
  child: ExpansionTile(
    iconColor: Colors.white70,
    collapsedIconColor: Colors.white70,
    title: const Text(
      'ℹ️ Familles aromatiques',
      style: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),
    children: [

      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [

          _legendChip('🟣 Fruits', const Color(0xFF6A1B9A)),

          _legendChip('🌸 Floral', const Color(0xFFE91E63)),

          _legendChip('🟢 Végétal', const Color(0xFF2E7D32)),

          _legendChip('🟠 Épices', const Color(0xFFEF6C00)),

          _legendChip('🟤 Boisé', const Color(0xFF6D4C41)),

          _legendChip('⚪ Minéral', const Color(0xFF546E7A)),

          _legendChip('☕ Torréfaction', const Color(0xFF4E342E)),

          _legendChip('⚫ Fumé', const Color(0xFF263238)),

          _legendChip('🔴 Animal', const Color(0xFF8E0000)),

          _legendChip('🌲 Résineux', const Color(0xFF1B5E20)),

          _legendChip('🟡 Évolution', const Color(0xFFB8860B)),

        ],
      ),

      const SizedBox(height: 12),
    ],
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
  color: getAromeColor(a['famille_id']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
  '${getAromeEmoji(a['code'])} ${a['libelle']}',
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
                    '${getBoucheEmoji(b['code'])} ${b['libelle']}',
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
            '${getMetEmoji(accord['code'])} ${accord['libelle']}',
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