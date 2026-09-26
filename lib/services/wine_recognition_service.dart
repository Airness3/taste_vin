import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WineRecognitionService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Ces mots apparaissent dans beaucoup de noms de vins.
  // Ils ne doivent jamais identifier seuls une appellation.
  static const Set<String> _weakWords = {
    'appellation',
    'blanc',
    'bouteille',
    'chateau',
    'clos',
    'controlee',
    'cru',
    'domaine',
    'grand',
    'mis',
    'origine',
    'protegee',
    'rouge',
    'saint',
    'vin',
  };

  // Petits mots grammaticaux ignorés dans le calcul.
  static const Set<String> _ignoredWords = {
    'a',
    'au',
    'aux',
    'd',
    'de',
    'des',
    'du',
    'et',
    'l',
    'la',
    'le',
    'les',
  };

  Future<Map<String, dynamic>?> findAppellation(
    String ocrText,
  ) async {
    final List<dynamic> appellations = await supabase
        .from('appellations')
        .select('id, nom');

    final String normalizedText = normalize(ocrText);
    final String repairedText =
        _repairBrokenWords(normalizedText);

    final List<String> ocrWords =
        _tokenize(repairedText);

    Map<String, dynamic>? bestMatch;

    double bestScore = 0.0;
    double bestPhraseScore = 0.0;

    int bestStrongMatches = 0;
    int bestImportantWordCount = 0;
    int bestUsefulWordCount = 0;

    debugPrint('========== RECONNAISSANCE ==========');
    debugPrint('OCR normalisé : $normalizedText');
    debugPrint('OCR réparé : $repairedText');

    for (final dynamic item in appellations) {
      final Map<String, dynamic> appellation =
          Map<String, dynamic>.from(item as Map);

      final String originalName =
          appellation['nom']?.toString() ?? '';

      final String normalizedName =
          normalize(originalName);

      final List<String> nameWords =
          _tokenize(normalizedName);

      final List<String> usefulWords = nameWords
          .where(
            (word) =>
                word.length >= 3 &&
                !_ignoredWords.contains(word),
          )
          .toList();

      if (usefulWords.isEmpty) {
        continue;
      }

      final List<String> importantWords = usefulWords
          .where(
            (word) =>
                !_weakWords.contains(word) &&
                !_ignoredWords.contains(word),
          )
          .toList();

      final int importantWordCount =
          importantWords.length;

      double earnedWeight = 0.0;
      double possibleWeight = 0.0;

      int strongMatches = 0;

      for (final String expectedWord in usefulWords) {
        final bool weakWord =
            _weakWords.contains(expectedWord);

        final double wordWeight = weakWord
            ? 0.20
            : _wordWeight(expectedWord);

        possibleWeight += wordWeight;

        final _WordMatch match =
            _findBestWordMatch(
          expectedWord,
          ocrWords,
        );

        if (!match.found) {
          continue;
        }

        if (weakWord) {
          earnedWeight +=
              wordWeight * match.similarity;

          continue;
        }

        earnedWeight +=
            wordWeight * match.similarity;

        strongMatches++;
      }

      if (strongMatches == 0 ||
          possibleWeight == 0) {
        continue;
      }

      final double wordScore =
          earnedWeight / possibleWeight;

      final double phraseScore =
          _phraseSimilarity(
        normalizedName,
        repairedText,
      );

      final double importantWordCoverage =
          _importantWordCoverage(
        usefulWords,
        ocrWords,
      );

      // L'expression complète est prioritaire.
      // Cela évite que "Saint Denis" suffise à choisir
      // automatiquement "Clos Saint-Denis".
      double score =
          (phraseScore * 0.85) +
          (importantWordCoverage * 0.15);

      // Le score par mots ne peut maintenant apporter
      // qu'une petite confirmation.
      //
      // Il ne remplace plus entièrement le score global.
      if (wordScore > score &&
          phraseScore >= 0.70) {
        final double wordConfirmation =
            (wordScore - score) * 0.25;

        score += wordConfirmation;
      }

      // Bonus pour une appellation composée.
      //
      // Une appellation avec plusieurs mots distinctifs
      // est plus précise qu'une appellation régionale
      // constituée d'un seul mot.
      if (importantWordCount >= 2 &&
          phraseScore >= 0.75) {
        score += 0.08;

        if (importantWordCoverage >= 0.50) {
          score += 0.04;
        }

        if (importantWordCoverage >= 0.99) {
          score += 0.03;
        }
      }

      // Bonus supplémentaire pour les appellations
      // particulièrement détaillées.
      if (importantWordCount >= 3 &&
          phraseScore >= 0.75 &&
          importantWordCoverage >= 0.65) {
        score += 0.08;
      }

      // Correspondance exacte dans le texte réparé.
      if (repairedText.contains(normalizedName)) {
        score += 0.08;
      }

      if (score > 1.0) {
        score = 1.0;
      }

      if (score >= 0.35) {
        debugPrint(
          '$originalName : '
          '${(score * 100).round()} % '
          '| phrase : '
          '${(phraseScore * 100).round()} % '
          '| couverture : '
          '${(importantWordCoverage * 100).round()} % '
          '| mots forts reconnus : $strongMatches '
          '| mots importants : $importantWordCount',
        );
      }

      final bool betterScore =
          score > bestScore;

      final bool nearlyAsGoodButMoreSpecific =
          bestMatch != null &&
          score >= bestScore - 0.20 &&
          importantWordCount >
              bestImportantWordCount &&
          phraseScore >= 0.75 &&
          importantWordCoverage >= 0.50;

      final bool sameScoreButBetterPhrase =
          (score - bestScore).abs() < 0.001 &&
          phraseScore > bestPhraseScore;

      final bool sameScoreButMoreStrongWords =
          (score - bestScore).abs() < 0.001 &&
          strongMatches > bestStrongMatches;

      final bool sameQualityButMoreSpecific =
          (score - bestScore).abs() < 0.001 &&
          strongMatches == bestStrongMatches &&
          importantWordCount >
              bestImportantWordCount;

      final bool sameEverythingButLongerName =
          (score - bestScore).abs() < 0.001 &&
          strongMatches == bestStrongMatches &&
          importantWordCount ==
              bestImportantWordCount &&
          usefulWords.length >
              bestUsefulWordCount;

      if (betterScore ||
          nearlyAsGoodButMoreSpecific ||
          sameScoreButBetterPhrase ||
          sameScoreButMoreStrongWords ||
          sameQualityButMoreSpecific ||
          sameEverythingButLongerName) {
        bestScore = score;
        bestPhraseScore = phraseScore;
        bestStrongMatches = strongMatches;
        bestImportantWordCount =
            importantWordCount;
        bestUsefulWordCount =
            usefulWords.length;
        bestMatch = appellation;
      }
    }

    debugPrint(
      'MEILLEURE APPELLATION : '
      '${bestMatch?['nom']}',
    );

    debugPrint(
      'MEILLEUR SCORE : '
      '${(bestScore * 100).round()} %',
    );

    debugPrint(
      'MEILLEUR SCORE DE PHRASE : '
      '${(bestPhraseScore * 100).round()} %',
    );

    debugPrint(
      'MOTS FORTS RECONNUS : '
      '$bestStrongMatches',
    );

    debugPrint(
      'MOTS IMPORTANTS : '
      '$bestImportantWordCount',
    );

    debugPrint('====================================');

    // Ne pas inventer une appellation lorsque
    // les preuves sont insuffisantes.
    if (bestMatch == null ||
        bestScore < 0.60 ||
        bestStrongMatches == 0) {
      return null;
    }

    return bestMatch;
  }

  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('æ', 'ae')
        .replaceAll('œ', 'oe')
        .replaceAll('ç', 'c')
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
        .replaceAll('ÿ', 'y')
        .replaceAll('-', ' ')
        .replaceAll('–', ' ')
        .replaceAll('—', ' ')
        .replaceAll("'", ' ')
        .replaceAll('’', ' ')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  int? extractMillesime(String text) {
    final String correctedText = text
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1');

    final RegExp regex = RegExp(
      r'\b(19|20)\d{2}\b',
    );

    final int currentYear =
        DateTime.now().year;

    for (final RegExpMatch match
        in regex.allMatches(correctedText)) {
      final int? value =
          int.tryParse(match.group(0)!);

      if (value != null &&
          value >= 1900 &&
          value <= currentYear) {
        return value;
      }
    }

    return null;
  }

  List<String> _tokenize(String text) {
    return text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  double _wordWeight(String word) {
    if (word.length >= 10) {
      return 3.0;
    }

    if (word.length >= 7) {
      return 2.5;
    }

    if (word.length >= 5) {
      return 2.0;
    }

    return 1.5;
  }

  _WordMatch _findBestWordMatch(
    String expectedWord,
    List<String> ocrWords,
  ) {
    if (ocrWords.contains(expectedWord)) {
      return const _WordMatch(
        found: true,
        similarity: 1.0,
      );
    }

    double bestSimilarity = 0.0;

    for (final String candidate in ocrWords) {
      if (candidate.length < 4) {
        continue;
      }

      final int lengthDifference =
          (expectedWord.length -
                  candidate.length)
              .abs();

      if (lengthDifference > 2) {
        continue;
      }

      final double similarity =
          _similarity(
        expectedWord,
        candidate,
      );

      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
      }
    }

    final double requiredSimilarity =
        expectedWord.length <= 5
            ? 0.80
            : 0.78;

    return _WordMatch(
      found:
          bestSimilarity >= requiredSimilarity,
      similarity: bestSimilarity,
    );
  }

  double _similarity(
    String first,
    String second,
  ) {
    final int distance =
        _levenshtein(first, second);

    final int maxLength =
        first.length > second.length
            ? first.length
            : second.length;

    if (maxLength == 0) {
      return 1.0;
    }

    return 1.0 - (distance / maxLength);
  }

  int _levenshtein(
    String first,
    String second,
  ) {
    final List<List<int>> matrix =
        List.generate(
      first.length + 1,
      (_) => List<int>.filled(
        second.length + 1,
        0,
      ),
    );

    for (int i = 0;
        i <= first.length;
        i++) {
      matrix[i][0] = i;
    }

    for (int j = 0;
        j <= second.length;
        j++) {
      matrix[0][j] = j;
    }

    for (int i = 1;
        i <= first.length;
        i++) {
      for (int j = 1;
          j <= second.length;
          j++) {
        final int substitutionCost =
            first[i - 1] == second[j - 1]
                ? 0
                : 1;

        final int deletion =
            matrix[i - 1][j] + 1;

        final int insertion =
            matrix[i][j - 1] + 1;

        final int substitution =
            matrix[i - 1][j - 1] +
                substitutionCost;

        matrix[i][j] = _minimum(
          deletion,
          insertion,
          substitution,
        );
      }
    }

    return matrix[first.length]
        [second.length];
  }

  String _repairBrokenWords(String text) {
    String repaired = text;

    final Map<String, String> repairs = {
      'bour gogne': 'bourgogne',
      'bea une': 'beaune',
      'mont pellier': 'montpellier',
    };

    repairs.forEach((broken, fixed) {
      repaired =
          repaired.replaceAll(broken, fixed);
    });

    return repaired;
  }

  double _phraseSimilarity(
    String appellationText,
    String ocrText,
  ) {
    final String normalizedAppellation =
        normalize(appellationText);

    final String normalizedOcr =
        normalize(ocrText);

    final List<String> appellationWords =
        _tokenize(normalizedAppellation)
            .where(
              (word) =>
                  word.isNotEmpty &&
                  !_ignoredWords.contains(word),
            )
            .toList();

    final List<String> ocrWords =
        _tokenize(normalizedOcr)
            .where((word) => word.isNotEmpty)
            .toList();

    if (appellationWords.isEmpty ||
        ocrWords.isEmpty) {
      return 0.0;
    }

    final String targetWithSpaces =
        appellationWords.join(' ');

    final String targetWithoutSpaces =
        appellationWords.join();

    final int expectedWordCount =
        appellationWords.length;

    double bestSimilarity = 0.0;

    final int minimumWindowSize =
        expectedWordCount > 1
            ? expectedWordCount - 1
            : 1;

    final int maximumWindowSize =
        expectedWordCount + 2;

    for (
      int windowSize = minimumWindowSize;
      windowSize <= maximumWindowSize;
      windowSize++
    ) {
      if (windowSize > ocrWords.length) {
        continue;
      }

      for (
        int startIndex = 0;
        startIndex <=
            ocrWords.length - windowSize;
        startIndex++
      ) {
        final List<String> window =
            ocrWords.sublist(
          startIndex,
          startIndex + windowSize,
        );

        final String windowWithSpaces =
            window.join(' ');

        final String windowWithoutSpaces =
            window.join();

        final double spacedSimilarity =
            _similarity(
          targetWithSpaces,
          windowWithSpaces,
        );

        final double compactSimilarity =
            _similarity(
          targetWithoutSpaces,
          windowWithoutSpaces,
        );

        double currentSimilarity =
            compactSimilarity >
                    spacedSimilarity
                ? compactSimilarity
                : spacedSimilarity;

        final int extraWords =
            (windowSize -
                    expectedWordCount)
                .abs();

        if (extraWords > 0) {
          currentSimilarity -=
              extraWords * 0.025;
        }

        if (currentSimilarity >
            bestSimilarity) {
          bestSimilarity =
              currentSimilarity;
        }
      }
    }

    if (bestSimilarity < 0.0) {
      return 0.0;
    }

    if (bestSimilarity > 1.0) {
      return 1.0;
    }

    return bestSimilarity;
  }

  double _importantWordCoverage(
    List<String> appellationWords,
    List<String> ocrWords,
  ) {
    final List<String> importantWords =
        appellationWords
            .where(
              (word) =>
                  word.length >= 3 &&
                  !_ignoredWords
                      .contains(word) &&
                  !_weakWords.contains(word),
            )
            .toList();

    if (importantWords.isEmpty) {
      return 0.0;
    }

    int foundWords = 0;

    for (final String expectedWord
        in importantWords) {
      final _WordMatch match =
          _findBestWordMatch(
        expectedWord,
        ocrWords,
      );

      if (match.found) {
        foundWords++;
      }
    }

    return foundWords /
        importantWords.length;
  }

  int _minimum(
    int first,
    int second,
    int third,
  ) {
    int result = first;

    if (second < result) {
      result = second;
    }

    if (third < result) {
      result = third;
    }

    return result;
  }
}

class _WordMatch {
  final bool found;
  final double similarity;

  const _WordMatch({
    required this.found,
    required this.similarity,
  });
}