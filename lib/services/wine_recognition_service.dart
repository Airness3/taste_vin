import 'package:supabase_flutter/supabase_flutter.dart';

class WineRecognitionService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> findAppellation(
  String ocrText,
) async {

    final appellations = await supabase
        .from('appellations')
        .select('id, nom');

    final normalizedText = normalize(ocrText);

    Map<String, dynamic>? bestMatch;

    int bestScore = 0;

    for (final appellation in appellations) {

      final nom = normalize(
        appellation['nom'].toString(),
      );

      int score = 0;

      for (final word in nom.split(' ')) {

        if (word.length < 3) {
          continue;
        }

        if (normalizedText.contains(word)) {

          // Les mots longs valent plus
          score += word.length;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestMatch = appellation;
      }
    }

    return bestMatch;
  }

  String normalize(String text) {

    return text
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ô', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u');
  }

  int? extractMillesime(String text) {

    final regex = RegExp(
      r'\b(19|20)\d{2}\b',
    );

    final match = regex.firstMatch(text);

    if (match != null) {
      return int.tryParse(
        match.group(0)!,
      );
    }

    return null;
  }
}