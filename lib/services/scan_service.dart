import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/scan_history.dart';

class ScanService {
  final supabase = Supabase.instance.client;

  Future<List<ScanHistory>> getHistory(String profilId) async {
    final data = await supabase
        .from("historique_scans")
        .select("*, vins(*)")
        .eq("profil_id", profilId)
        .order("date_scan", ascending: false);

    return data.map((e) => ScanHistory.fromJson(e)).toList();
  }

  Future<void> addScan(String profilId, int vinId) async {
    await supabase.from("historique_scans").insert({
      "profil_id": profilId,
      "vin_id": vinId,
      "date_scan": DateTime.now().toIso8601String(),
    });
  }
}
