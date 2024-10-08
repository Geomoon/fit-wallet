import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? '';
  static String dbName = dotenv.env['DB_NAME'] ?? 'fit_wallet';
}
