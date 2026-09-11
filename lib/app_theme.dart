import 'package:flutter/material.dart';

class TasteVinTheme {
  static const Color metalSilver = Color(0xFFC0C0C0);
  static const Color vertBouteille = Color(0xFF0A3D2E);
  static const Color creme = Color(0xFFF4E7A1);
  static const Color ambre = Color(0xFFD45A1F);
  static const Color rubis = Color(0xFFA32020);
  static const Color bordeaux = Color(0xFF5A0F1A);
  static const Color or = Color(0xFFF7C468);

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: creme,
      primaryColor: vertBouteille,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: vertBouteille,
        onPrimary: Colors.white,
        secondary: rubis,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: creme,
        onBackground: vertBouteille,
        surface: metalSilver,
        onSurface: vertBouteille,
      ),

      // TITRES & TEXTES
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: vertBouteille,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: vertBouteille,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: vertBouteille,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          color: bordeaux,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          color: vertBouteille,
        ),
      ),

      // APPBAR
      appBarTheme: AppBarTheme(
        backgroundColor: vertBouteille,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black45,
      ),

      // BOUTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: metalSilver,
          foregroundColor: vertBouteille,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
      ),

      // CHAMPS DE TEXTE
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: vertBouteille),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: metalSilver, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: rubis, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // CARTES
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // NAVIGATION BAS
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: vertBouteille,
        selectedItemColor: or,
        unselectedItemColor: metalSilver,
        showUnselectedLabels: false,
      ),
    );
  }
}
