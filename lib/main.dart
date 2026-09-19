import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vgjytsszmhjxcqdwaskr.supabase.co',
    anonKey: 'sb_publishable_UxeemH_YPAPTtyHA-q45Rg_o4H5l2ZC',
  );

  runApp(const TasteVinApp());
}
