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

    Map<String, dynamic>? bestMatch;

    int longestLength = 0;

    for (final appellation in appellations) {
      final nom = appellation['nom']
          .toString()
          .toLowerCase();

      bool allWordsFound = true;

      for (final word in nom.split(' ')) {
        if (word.length < 3) continue;

        if (!normalizedText.contains(word)) {
          allWordsFound = false;
          break;
        }
      }

      if (allWordsFound) {
        if (nom.length > longestLength) {
          longestLength = nom.length;
          bestMatch = appellation;
        }
      }
    }

    return bestMatch;
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