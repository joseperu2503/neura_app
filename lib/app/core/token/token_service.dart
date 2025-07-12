import 'package:jwt_decoder/jwt_decoder.dart';

abstract class TokenService {
  int getRemainingTime(String token);
  bool isValid(String token);
}

class TokenServiceImpl implements TokenService {
  @override
  int getRemainingTime(String? token) {
    try {
      if (token == null) return 0;
      final getRemainingTime = JwtDecoder.getRemainingTime(token);
      return getRemainingTime.inSeconds;
    } catch (e) {
      return 0;
    }
  }

  @override
  bool isValid(String? token) {
    try {
      if (token == null) return false;

      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }
}
