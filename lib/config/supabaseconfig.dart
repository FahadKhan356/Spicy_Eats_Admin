import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseURL = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://mrqaapzhzeqvarrtfkgv.supabase.co',
);

const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ycWFhcHpoemVxdmFycnRma2d2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI3OTc4NTIsImV4cCI6MjAzODM3Mzg1Mn0.mdcsEEmN9dSmY1pbEIOlluUsvNmdrItsQ453omyrxsM',
);

const dishImagesBucket = String.fromEnvironment(
  'DISH_IMAGES_BUCKET',
  defaultValue: 'Dish_Images',
);

final supabaseClient = Supabase.instance.client;
