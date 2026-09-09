import 'package:flutter/material.dart';
import 'package:taste_vin/widgets/taste_vin_loader.dart'; // ✔ ton loader Taste Vin

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({super.key});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _loading = true;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    await Future.delayed(const Duration(seconds: 2)); // simulation
    setState(() {
      _loading = false;
      _result = {
        "nom": "Château Margaux",
        "annee": 2015,
        "region": "Bordeaux",
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // crème Taste Vin
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E), // vert bouteille Taste Vin
        title: const Text(
          "Résultat du scan",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: _loading
          ? const TasteVinLoader() // ✔ ton loader Taste Vin
          : _resultView(),
    );
  }

  Widget _resultView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _result?["nom"] ?? "Vin inconnu",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A3D2E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Année : ${_result?["annee"]}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "Région : ${_result?["region"]}",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
