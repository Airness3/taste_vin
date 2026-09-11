import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cave_entry.dart';

class CaveService {
  final supabase = Supabase.instance.client;

  Future<List<CaveEntry>> getCave(String profilId) async {
    final data = await supabase
        .from("cave_utilisateur")
        .select("*, vins(*)")
        .eq("profil_id", profilId);

    return data.map((e) => CaveEntry.fromJson(e)).toList();
  }

  Future<void> addBottle(String profilId, int vinId) async {
    await supabase.from("cave_utilisateur").insert({
      "profil_id": profilId,
      "vin_id": vinId,
      "quantite": 1,
    });
  }

  Future<void> removeBottle(int entryId) async {
    await supabase.from("cave_utilisateur").delete().eq("id", entryId);
  }
}
