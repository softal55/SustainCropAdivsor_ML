import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static String get authUrl =>
      dotenv.env['AUTH_URL'] ?? _throwMissing('AUTH_URL');

  static String get fieldsUrl =>
      dotenv.env['FIELDS_URL'] ?? _throwMissing('FIELDS_URL');

  static String get predictUrl =>
      dotenv.env['PREDICT_URL'] ?? _throwMissing('PREDICT_URL');

  static String _throwMissing(String key) {
    throw Exception('Environment variable "$key" is missing in .env file');
  }
}
