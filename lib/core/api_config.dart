import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get beeceptorApiKey => dotenv.env['BEECEPTOR_API_KEY'] ?? '';
  static String get beeceptorBaseUrl => dotenv.env['BEECEPTOR_BASE_URL']?? '';
}
