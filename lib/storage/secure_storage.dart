import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SecureStorage secStore = new SecureStorage();

class SecureStorage {
  final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyToken = 'token';
  static const _tokenExpiry = 'tokenExpiry';
  static const _accessLevel = 'accessLevel';
  static const _accessLevels = 'accessLevels';
  static const _isAdmin = 'isAdmin';
  static const _isManager = 'isManager';
  static const _isClimber = 'isClimber';
  static const _isAnonymous = 'isAnonymous';

  Future<String> secureRead(String key) async {
    String value = await _storage.read(key: key);
    return value;
  }

  Future<Map<String, String>> secureReadAll() async {
    Map<String, String> allValues = await _storage.readAll();
    return allValues;
  }

  Future<void> secureDelete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> secureDeleteAll() async {
    await _storage.deleteAll();
  }


  Future<void> secureWrite(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String> getUsername() {
    return _storage.read(key: _keyUsername);
  }

  Future<String> getAccessLevel() {
    return _storage.read(key: _accessLevel);
  }

  Future<void> changeAccessLevel(String value) async {
    _storage.write(key: _accessLevel, value: value);
  }

  Future<Map<String, bool>> getAccessLevels() async {
    final value = await _storage.read(key: _accessLevels);
    
    return Map<String, bool>.from(json.decode(value));
  }

  Future setAccessLevels(Map<String, bool> levels) async {
    final value = json.encode(levels);
    return _storage.write(key: _accessLevels, value: value);
  }

}