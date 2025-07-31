import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> remove(String key);
}

class SecureStorageService implements StorageService {
  SecureStorageService();

  static AndroidOptions _getAndroidOptions() => const AndroidOptions();

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<T?> get<T>(String key) async {
    try {
      final data = await _storage.read(key: key);
      if (data == null) return null;
      final value = jsonDecode(data);
      return value['data'] as T;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> set<T>(String key, T value) async {
    final data = jsonEncode({'data': value});
    await _storage.write(key: key, value: data);
  }

  @override
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }
}
