import 'package:neura_app/app/core/storage/storage_keys.dart';
import 'package:neura_app/app/core/storage/storage_service.dart';
import 'package:neura_app/app/core/token/token_service.dart';

abstract class AuthLocalDataSource {
  Future<void> set(String token);
  Future<void> remove();
  Future<bool> validate();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService storageService;
  final TokenService tokenService;

  AuthLocalDataSourceImpl({
    required this.storageService,
    required this.tokenService,
  });

  @override
  Future<void> set(String token) async {
    await storageService.set<String>(StorageKeys.token, token);
  }

  Future<String?> getToken() async {
    final token = await storageService.get<String>(StorageKeys.token);
    return token;
  }

  @override
  Future<void> remove() async {
    await storageService.remove(StorageKeys.token);
  }

  @override
  Future<bool> validate() async {
    final String? token = await getToken();

    if (token == null) return false;

    return tokenService.isValid(token);
  }
}
