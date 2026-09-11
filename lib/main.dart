import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vgjytsszmhjxcqdwaskr.supabase.co/',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZnanl0c3N6bWhqeGNxZHdhc2tyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU2MzUyMDEsImV4cCI6MjEwMTIxMTIwMX0.9dKSieLssfHXmeIyuO2OVpe98icePlBc8p01ipdfZOo',
  );

  runApp(const TasteVinApp());
}
