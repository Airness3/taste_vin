import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profil.dart';

class ProfilService {
  final supabase = Supabase.instance.client;

  Future<Profil?> getProfil(String profilId) async {
    final data =
        await supabase.from("profils").select().eq("id", profilId).single();

    return Profil.fromJson(data);
  }

  Future<void> updatePseudo(String profilId, String pseudo) async {
    await supabase.from("profils").update({
      "pseudo": pseudo,
    }).eq("id", profilId);
  }
}
