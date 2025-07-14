import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static init() async {
    await dotenv.load();
  }

  static String baseUrl = dotenv.get('BASE_URL');
  static String encryptionKey = dotenv.get('ENCRYPTION_KEY');
  static bool encrypt = dotenv.get('ENCRYPT') == 'true';
}
