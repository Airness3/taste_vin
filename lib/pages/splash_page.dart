import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D2E), // Vert bouteille Taste Vin
      body: Center(
        child: Image.asset(
          'assets/icons/icone_appli_clean.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
