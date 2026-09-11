import 'package:supabase_flutter/supabase_flutter.dart';

class SommelierService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getSommelierData(int styleId) async {
    final data = await supabase
        .from("styles_vin")
        .select("""
          *,
          temperatures_service(*),
          style_vin_verre(type_verre_id, types_verre(*)),
          style_vin_accord(met_id, mets(*)),
          style_vin_arome(arome_id, aromes(*)),
          style_vin_bouche(profil_bouche_id, profils_bouche(*)),
          style_vin_robe(robe_id, robes(*))
        """)
        .eq("id", styleId)
        .single();

    return data;
  }
}
