import 'package:supabase_flutter/supabase_flutter.dart';

class SuggestionsService {
  final supabase = Supabase.instance.client;

  Future<void> sendSuggestion(String profilId, String message) async {
    await supabase.from("suggestions").insert({
      "profil_id": profilId,
      "message": message,
      "date_suggestion": DateTime.now().toIso8601String(),
      "statut": "nouveau",
    });
  }
}
