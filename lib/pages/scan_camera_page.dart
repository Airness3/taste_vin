import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ocr_service.dart';
import 'scan_result_page.dart';

class ScanCameraPage extends StatefulWidget {
  const ScanCameraPage({super.key});

  @override
  State<ScanCameraPage> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage> {
  int? selectedColorId;

  final ImagePicker _picker = ImagePicker();
  final OcrService _ocrService = OcrService();

  bool isLoading = false;

Future<void> _showScanTipsDialog() async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          '📸 Conseils pour un scan réussi',
        ),
        content: const Text(
          '• Centre l’étiquette dans la photo\n\n'
          '• Approche-toi suffisamment pour que le texte soit lisible\n\n'
          '• Évite les reflets et les zones sombres\n\n'
          '• Vérifie que la photo est nette avant de valider',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              startScan();
            },
            child: const Text(
              'Commencer le scan',
            ),
          ),
        ],
      );
    },
  );
}

  Future<void> startScan() async {
    try {
      setState(() {
        isLoading = true;
      });

      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final text = await _ocrService.readText(
        File(image.path),
      );

      debugPrint("========== OCR ==========");
      debugPrint(text);
      debugPrint("=========================");

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(
            ocrText: text,
            couleurId: selectedColorId!,
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      debugPrint("ERREUR OCR : $e");

      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur : $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D2E),
        title: const Text(
          "Scanner un vin",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.camera_alt,
              size: 80,
              color: Color(0xFF0A3D2E),
            ),

            const SizedBox(height: 20),

            const Text(
              "Quel type de vin souhaitez-vous scanner ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _buildColorButton("⚪ Blanc", 1),
            _buildColorButton("🔴 Rouge", 2),
            _buildColorButton("🩷 Rosé", 3),
            _buildColorButton("🫧 Effervescent", 4),
            _buildColorButton("🟠 Orange", 5),

 Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(12),
  ),
  child: const Column(
    children: [
      Icon(
        Icons.center_focus_strong,
        color: Color(0xFF0A3D2E),
      ),
      SizedBox(height: 8),
      Text(
        "Centre l'étiquette et assure-toi que le texte est bien net.",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 6),
      Text(
        "Évite les reflets, le flou et les photos prises de trop loin.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 13,
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedColorId == null || isLoading
                    ? null
                    : _showScanTipsDialog,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Scanner l'étiquette",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildColorButton(String label, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: selectedColorId == value
            ? Colors.green.shade100
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selectedColorId == value
                ? Colors.green
                : Colors.grey.shade300,
          ),
        ),
        title: Text(label),
        onTap: () {
          setState(() {
            selectedColorId = value;
          });
        },
      ),
    );
  }
}