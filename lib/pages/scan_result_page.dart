import 'package:flutter/material.dart';
import '../services/wine_recognition_service.dart';
import '../services/wine_profile_service.dart';
import '../theme/app_colors.dart';

class ScanResultPage extends StatefulWidget {
  final String ocrText;
  final int couleurId;

  const ScanResultPage({
    super.key,
    required this.ocrText,
    required this.couleurId,
  });

  @override
  State<ScanResultPage> createState() =>
      _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {

  final WineRecognitionService _recognitionService =
    WineRecognitionService();

final WineProfileService _profileService =
    WineProfileService();

bool _loading = true;

Map<String, dynamic>? _wineProfile;

String? _appellation;

int? _millesime;

@override
void initState() {
  super.initState();
  _loadWine();
}

Future<void> _loadWine() async {
  try {
    final appellation =
        await _recognitionService.findAppellation(
      widget.ocrText,
    );

    final millesime =
        _recognitionService.extractMillesime(
      widget.ocrText,
    );

    if (appellation == null) {
      setState(() {
        _loading = false;
        _millesime = millesime;
      });
      return;
    }

    final profile =
        await _profileService.getWineProfile(
      appellationId: appellation['id'],
      couleurId: widget.couleurId,
    );


    setState(() {
  _loading = false;

  _appellation = appellation['nom'];

  _millesime = millesime;

 _wineProfile = profile;  
});
  } catch (e) {

  setState(() {
    _loading = false;

    _appellation = e.toString();
  });

}  
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "Résultat du scan",
          style: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

  // HERO CARD

  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),

    decoration: BoxDecoration(
      gradient: const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.bottleGreen,
    Color(0xFF091D17),
  ],
),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "🍷 Appellation",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          _appellation ?? "Analyse en cours...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Text(
      "Millésime ${_millesime ?? "-"}",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),

    const SizedBox(height: 10),
  ],
),
),
      ],
    ),
  ),

  const SizedBox(height: 20),

  // TERROIR

  if (_wineProfile != null)
    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "📍 Terroir",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.copper,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            "Région : ${_wineProfile!['region']?['nom'] ?? '-'}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Sous-région : ${_wineProfile!['sousRegion']?['nom'] ?? '-'}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    ),

  const SizedBox(height: 20),
if (_wineProfile != null)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "🍷 Style du vin",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.copper,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          _wineProfile!['style']?['libelle'] ?? '-',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          _wineProfile!['style']?['description'] ?? '',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    ),
  ),

const SizedBox(height: 20),

if (_wineProfile != null)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "🍇 Cépages",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.copper,
          ),
        ),

        const SizedBox(height: 16),

        ...(_wineProfile!['cepages'] as List)
            .map(
              (cepage) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "• ${cepage['nom']}",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            )
            .toList(),
      ],
    ),
  ),

const SizedBox(height: 20),

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