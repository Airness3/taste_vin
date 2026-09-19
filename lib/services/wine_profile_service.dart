import 'package:supabase_flutter/supabase_flutter.dart';

class WineProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getWineProfile({
    required int appellationId,
    required int couleurId,
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
      };
    } catch (e) {
      return null;
    }
  }
}