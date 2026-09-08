import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static const _keyfullName = "fullname";
  static const _keyEmail = "email";
  static const _accessTokenKey = "accessToken";

  static Future setFullName(String fullName) async =>
      await _storage.write(key: _keyfullName, value: fullName);

  static Future<String?> getFullName() async =>
      await _storage.read(key: _keyfullName);

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyEmail, value: email);

  static Future<String?> getEmail() async =>
      await _storage.read(key: _keyEmail);

  static Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );
  }

  /// Get JWT Access Token
  static Future<String?> getAccessToken() async {
    return await _storage.read(
      key: _accessTokenKey,
    );
  }

  /// Delete JWT Access Token
  static Future<void> deleteAccessToken() async {
    await _storage.delete(
      key: _accessTokenKey,
    );
  }

  static Future clearStorageData() async => await _storage.deleteAll();


}
