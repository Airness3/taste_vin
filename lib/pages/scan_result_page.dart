import 'package:flutter/material.dart';
import '../services/wine_recognition_service.dart';
import '../services/wine_profile_service.dart';
import '../theme/app_colors.dart';
import 'dart:io';
import 'sommelier_page.dart';
import 'cellar_page.dart';
import 'favorites_page.dart';

class ScanResultPage extends StatefulWidget {
  final String ocrText;
  final int couleurId;
  final String imagePath;

  const ScanResultPage({
    super.key,
    required this.ocrText,
    required this.couleurId,
    required this.imagePath,
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
  millesime: millesime,
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
Widget _buildPremiumButton({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.actionCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.silver.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.copper,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.silver,
            size: 24,
          ),
        ],
      ),
    ),
  );
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

// HERO PHOTO PREMIUM

ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: SizedBox(
    width: double.infinity,
    height: 550,
    child: Stack(
      fit: StackFit.expand,
      children: [

        Image.file(
          File(widget.imagePath),
          fit: BoxFit.contain,
        ),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
          ),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.copper,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "${_millesime ?? "-"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _appellation ?? "Analyse en cours...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "${_wineProfile?['sousRegion']?['nom'] ?? ''} • ${_wineProfile?['region']?['nom'] ?? ''}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
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

  border: Border.all(
    color: AppColors.copper.withOpacity(0.15),
    width: 1,
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.75),
      blurRadius: 20,
      offset: const Offset(0, 8),
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

_buildPremiumButton(
  icon: Icons.restaurant,
  title: "Conseils du sommelier",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SommelierPage(
  wineProfile: _wineProfile!,
),
      ),
    );
  },
),

const SizedBox(height: 12),

_buildPremiumButton(
  icon: Icons.wine_bar,
  title: "Ajouter à ma cave",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CellarPage(),
      ),
    );
  },
),

const SizedBox(height: 12),

_buildPremiumButton(
  icon: Icons.favorite,
  title: "Ajouter aux favoris",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesPage(),
      ),
    );
  },
),

const SizedBox(height: 12),

_buildPremiumButton(
  icon: Icons.star,
  title: "Noter ce vin",
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Module de notation bientôt disponible",
        ),
      ),
    );
  },
),
            ],
          ),
        ),
      ),
    );
  }
}