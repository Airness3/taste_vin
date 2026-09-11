import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/favori.dart';

class FavorisService {
  final supabase = Supabase.instance.client;

  Future<List<Favori>> getFavoris(String profilId) async {
    final data = await supabase
        .from("favoris")
        .select("*, vins(*)")
        .eq("profil_id", profilId);

    return data.map((e) => Favori.fromJson(e)).toList();
  }

  Future<void> addFavori(String profilId, int vinId) async {
    await supabase.from("favoris").insert({
      "profil_id": profilId,
      "vin_id": vinId,
      "date_ajout": DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavori(int favoriId) async {
    await supabase.from("favoris").delete().eq("id", favoriId);
  }
}
