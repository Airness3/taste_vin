import 'package:supabase_flutter/supabase_flutter.dart';

class WineRecognitionService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> findAppellation(
    String ocrText,
  ) async {
    final appellations = await supabase
        .from('appellations')
        .select('id, nom');

    final normalizedText = ocrText.toLowerCase();

    for (final appellation in appellations) {
      final nom = appellation['nom']
          .toString()
          .toLowerCase();

      if (normalizedText.contains(nom)) {
        return appellation;
      }
    }

    return null;
  }

  int? extractMillesime(String text) {
    final regex = RegExp(r'\b(19|20)\d{2}\b');

    final match = regex.firstMatch(text);

    if (match != null) {
      return int.tryParse(match.group(0)!);
    }

    return null;
  }
}
``