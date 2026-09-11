import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vin.dart';

class VinService {
  final supabase = Supabase.instance.client;

  Future<Vin?> getVin(int vinId) async {
    final data = await supabase.from("vins").select("""
          *,
          domaine(*),
          appellations(*),
          styles_vin(*)
        """).eq("id", vinId).single();

    return Vin.fromJson(data);
  }
}
