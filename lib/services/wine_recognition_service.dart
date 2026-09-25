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
    print("OCR NORMALISE");
print(normalizedText);

    Map<String, dynamic>? bestMatch;
    double bestScore = 0;

    for (final appellation in appellations) {
      final nom = normalize(
        appellation['nom'].toString(),
      );

      final words = nom
          .split(' ')
          .where((w) => w.length >= 3)
          .toList();

      if (words.isEmpty) {
        continue;
      }

      double score = 0;

      for (final word in words) {
        if (normalizedText.contains(word)) {
          score += word.length.toDouble();
        } else {
          final similarWords =
              normalizedText.split(RegExp(r'\s+'));

          for (final candidate in similarWords) {
            if (candidate.length < 3) {
              continue;
            }

            final similarity =
                _similarity(word, candidate);

            if (similarity >= 0.80) {
              score += word.length * similarity;
              break;
            }
          }
        }
      }

      final maxScore = words.fold<double>(
        0,
        (sum, w) => sum + w.length,
      );

      final double confidence =
    maxScore == 0
        ? 0.0
        : score / maxScore;

print(
  "${appellation['nom']} : ${(confidence * 100).round()}%",
);

if (
  confidence > bestScore ||
  (
    confidence == bestScore &&
    appellation['nom']
            .toString()
            .length >
        (bestMatch?['nom']
                ?.toString()
                .length ??
            0)
  )
) {
  bestScore = confidence;
  bestMatch = appellation;
 }
}

    print("OCR NORMALISE :");
print(normalizedText);

print("MEILLEURE APPELLATION");
print(bestMatch?['nom']);

print("MEILLEUR SCORE");
print(bestScore);

    // Seuil minimum de confiance
    if (bestScore < 0.45) {
      return null;
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
        .replaceAll('ü', 'u')
        .replaceAll('-', ' ')
        .replaceAll("'", ' ')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  int? extractMillesime(String text) {
    String corrected = text
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1');

    final regex = RegExp(
      r'\b(19|20)\d{2}\b',
    );

    final matches = regex.allMatches(corrected);

    for (final match in matches) {
      final value = int.tryParse(
        match.group(0)!,
      );

      if (value != null) {
        final currentYear =
            DateTime.now().year;

        if (value >= 1950 &&
            value <= currentYear) {
          return value;
        }
      }
    }

    return null;
  }

  double _similarity(
    String a,
    String b,
  ) {
    final distance =
        _levenshtein(a, b);

    final maxLength =
        a.length > b.length
            ? a.length
            : b.length;

    if (maxLength == 0) {
      return 1;
    }

    return 1 -
        (distance / maxLength);
  }

  int _levenshtein(
    String s,
    String t,
  ) {
    final List<List<int>> d =
        List.generate(
      s.length + 1,
      (_) => List.filled(
        t.length + 1,
        0,
      ),
    );

    for (int i = 0;
        i <= s.length;
        i++) {
      d[i][0] = i;
    }

    for (int j = 0;
        j <= t.length;
        j++) {
      d[0][j] = j;
    }

    for (int i = 1;
        i <= s.length;
        i++) {
      for (int j = 1;
          j <= t.length;
          j++) {
        final cost =
            s[i - 1] == t[j - 1]
                ? 0
                : 1;

        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] +
              cost,
        ].reduce(
          (a, b) =>
              a < b ? a : b,
        );
      }
    }

    return d[s.length][t.length];
  }
}