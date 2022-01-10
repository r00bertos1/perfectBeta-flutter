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
  //static const _askRefresh = 'askRefresh';
  // static const _refreshTimeout = 'refreshTimeout';
  // static const _verifierTimeout = 'verifierTimeout';

  // void init() {
  //   if (secStore.secureRead(_keyToken) != null) {
  //     //if (secureRead(_tokenExpiry) > DateTime.now().toString()) {
  //     //   timeout = secureRead(_tokenExpiry) - DateTime.now();
  //     //   refreshTimeoutTimeout = timeout - 300_000
  //
  //       if (refreshTimeoutTimeout >= 0) {
  //         state.refreshTimeout = setTimeout(() => {
  //           eventBus.$emit('ask-refresh-session', newState.token)
  //         }, refreshTimeoutTimeout)
  //       }
  //     //}
  //   }
  // }

  Future<String> secureRead(String key) async {
    String value = await _storage.read(key: key);
    return value;
  }

  Future<void> secureDelete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> secureWrite(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // void addNewItem(String key, String value) async {
  //   await _storage.write(
  //     key: key,
  //     value: value,
  //     iOptions: _getIOSOptions(),
  //   );
  // }
  //
  // IOSOptions _getIOSOptions() => IOSOptions(
  //   accountName: _getAccountName(),
  // );

  Future<String> getUsername() {
    return _storage.read(key: _keyUsername);
  }

  Future<String> getAccessLevel() {
    return _storage.read(key: _accessLevel);
  }

  bool isAuthenticated() {
   return _storage.read(key: _keyToken) != null;
  }

  bool isAdmin() {
    return _storage.read(key: _isAdmin) != null;
  }

  bool isManager() {
    return _storage.read(key: _isManager) != null;
  }

  bool isClimber() {
    return _storage.read(key: _isClimber) != null;
  }
  bool isAnonymous() {
    return _storage.read(key: _isAnonymous) != null;
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