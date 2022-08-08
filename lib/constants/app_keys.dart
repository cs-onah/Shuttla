import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppKeys {
  static const MAP_KEY = "AIzaSyAqllQphJiVoJDgI1Bs4a14wIw0ZlyHvFE";
  static String get secretMapKey => dotenv.env['SECRET_MAP_KEY']!;
}