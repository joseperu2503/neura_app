import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:neura_app/app/core/constants/environment.dart';

class EncryptService {
  static Future<Map<String, dynamic>> encrypt<T>(T data) async {
    String text = jsonEncode(data);

    Uint8List salt = _generateRandomBytes(8);

    Uint8List salted = Uint8List(0);
    Uint8List dx = Uint8List(0);

    while (salted.length < 48) {
      dx = _md5(Uint8List.fromList([
        ...dx,
        ...Environment.encryptionKey.codeUnits,
        ...salt,
      ]));
      salted = Uint8List.fromList([...salted, ...dx]);
    }

    Uint8List key = salted.sublist(0, 32);
    Uint8List iv = salted.sublist(32, 48);

    final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: IV(iv));

    return {
      "ct": encrypted.base64,
      "iv": hex.encode(iv),
      "s": hex.encode(salt),
    };
  }

  static Future<T> decrypt<T>(Map<String, dynamic> value) async {
    if (value['s'] == null || value['iv'] == null || value['ct'] == null) {
      throw Exception();
    }

    Uint8List salt = Uint8List.fromList(hex.decode(value['s']!));
    Uint8List iv = Uint8List.fromList(hex.decode(value['iv']!));

    Uint8List concatedPassphrase = Uint8List.fromList([
      ...Environment.encryptionKey.codeUnits,
      ...salt,
    ]);

    List<Uint8List> md5 = [];
    md5.add(_md5(concatedPassphrase));
    Uint8List result = md5[0];
    for (int i = 1; i < 3; i++) {
      md5.add(_md5(Uint8List.fromList([...md5[i - 1], ...concatedPassphrase])));
      result = Uint8List.fromList([...result, ...md5[i]]);
    }

    final key = Key(result.sublist(0, 32));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.fromBase64(value['ct']!);

    final decrypted = encrypter.decrypt(encrypted, iv: IV(iv));

    return jsonDecode(decrypted) as T;
  }

  static Uint8List _generateRandomBytes(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (index) => random.nextInt(256));
    return Uint8List.fromList(values);
  }

  static Uint8List _md5(Uint8List data) {
    return Uint8List.fromList(md5.convert(data).bytes);
  }
}
