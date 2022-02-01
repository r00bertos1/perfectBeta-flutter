import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyLogin = 'login';
  static const _keyPassword = 'password';
  static const _keyRememberMe = 'remember_me';

  static Future<void> secureDeleteAll() async {
    await _storage.deleteAll();
  }

  static Future setLogin(String login) async =>
      await _storage.write(key: _keyLogin, value: login);

  static Future<String> getLogin() async => await _storage.read(key: _keyLogin);

  static Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);

  static Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword);

  static Future setRememberMe(bool rememberMe) async {
    final value = json.encode(rememberMe);

    await _storage.write(key: _keyRememberMe, value: value);
  }

  static Future<bool> getRememberMe() async {
    final value = await _storage.read(key: _keyRememberMe);
    return value == null
        ? null
        : value.toLowerCase() == 'true'
            ? true
            : false;
  }
}
