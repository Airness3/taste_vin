import 'package:supabase_flutter/supabase_flutter.dart';

class WineProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getWineProfile({
  required int appellationId,
  required int couleurId,
  int? millesime,
}) async {
    try {
      final appellation = await supabase
          .from('appellations')
          .select()
          .eq('id', appellationId)
          .single();

      final region = appellation['region_id'] == null
          ? null
          : await supabase
              .from('regions')
              .select()
              .eq('id', appellation['region_id'])
              .single();

      final sousRegion = appellation['sous_region_id'] == null
          ? null
          : await supabase
              .from('sous_regions')
              .select()
              .eq('id', appellation['sous_region_id'])
              .single();

      final relationStyle = await supabase
          .from('appellation_couleur')
          .select()
          .eq('appellation_id', appellationId)
          .eq('couleur_id', couleurId)
          .single();

      final style = await supabase
          .from('styles_vin')
          .select()
          .eq('id', relationStyle['style_vin_id'])
          .single();

      final temperatureResponse = await supabase
    .from('temperatures_service')
    .select()
    .eq(
      'id',
      style['temperature_service_id'],
    );

      final temperature =
    temperatureResponse.isEmpty
        ? null
        : temperatureResponse.first;
      final verreRelation = await supabase
    .from('style_vin_verre')
    .select()
    .eq('style_vin_id', style['id'])
    .order('priorite')
    .limit(1);


final verre = verreRelation.isEmpty
    ? null
    : await supabase
        .from('types_verre')
        .select()
        .eq(
          'id',
          verreRelation.first['type_verre_id'],
        )
        .single();

String? typeVin;

switch (couleurId) {
  case 1:
    typeVin = 'BLANC';
    break;
  case 2:
    typeVin = 'ROUGE';
    break;
  case 4:
    typeVin = 'CHAMPAGNE';
    break;
}

Map<String, dynamic>? carafage;

if (millesime != null && typeVin != null) {
  final ageVin =
      DateTime.now().year - millesime;

  final regles = await supabase
      .from('regle_carafage')
      .select()
      .eq('type_vin', typeVin);

  final regle = regles.cast<Map<String, dynamic>?>().firstWhere(
        (r) =>
            ageVin >= r!['age_min'] &&
            ageVin <= r['age_max'],
        orElse: () => null,
      );

  if (regle != null) {
    final preparation = await supabase
        .from('type_preparation')
        .select()
        .eq(
          'id',
          regle['type_preparation_id'],
        )
        .single();

    carafage = {
      'type': preparation,
      'regle': regle,
      'ageVin': ageVin,
    };
  }
}

final robeRelation = await supabase
    .from('style_vin_robe')
    .select()
    .eq('style_vin_id', style['id'])
    .order('priorite')
    .limit(1);

final robe = robeRelation.isEmpty
    ? null
    : await supabase
        .from('robes')
        .select()
        .eq(
          'id',
          robeRelation.first['robe_id'],
        )
        .single();

        print("ROBE");
print(robe);

final aromesRelations = await supabase
    .from('style_vin_arome')
    .select()
    .eq('style_vin_id', style['id'])
    .order('priorite');

final aromeIds = aromesRelations
    .map((e) => e['arome_id'])
    .toList();

final aromes = aromeIds.isEmpty
    ? []
    : await supabase
        .from('aromes')
        .select()
        .inFilter('id', aromeIds);

print("AROMES");
print(aromes);


      final relationsCepages = await supabase
          .from('appellation_cepage')
          .select()
          .eq('appellation_id', appellationId)
          .eq('couleur_id', couleurId);

      final cepageIds = relationsCepages
          .map((e) => e['cepage_id'])
          .toList();

      final cepages = cepageIds.isEmpty
          ? []
          : await supabase
              .from('cepages')
              .select()
              .inFilter('id', cepageIds);

      return {
        'appellation': appellation,
        'region': region,
        'sousRegion': sousRegion,
        'style': style,
        'cepages': cepages,
        'temperature': temperature,
        'verre': verre,
        'carafage': carafage,
        'robe': robe,
        'aromes': aromes,
      };
 } catch (e) {
  throw Exception(
    "WineProfileService ERROR : $e",
  );
}
  }
}