import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/domain/user.dart';

class AuthenticationLocalService {
  final FlutterSecureStorage _storage;
  AuthenticationLocalService(this._storage);

  static const _authUserKey = 'authUser';
  static const _bearerTokenKey = 'bearerToken';
  User? _cachedUser;
  String? _cachedBearerToken;

  Future<void> saveBearerToken({required String bearerToken}) async {
    try {
      _cachedBearerToken = bearerToken;
      _storage.write(key: _bearerTokenKey, value: bearerToken);
    } catch (error) {
      _storage.deleteAll();
    }
  }

  Future<String?> readBearerToken() async {
    try {
      if (_cachedBearerToken != null) {
        return _cachedBearerToken;
      }
      return _cachedBearerToken = await _storage.read(key: _bearerTokenKey);
    } catch (error) {
      return null;
    }
  }

  Future<void> clearStoredBearerToken() async {
    try {
      _cachedBearerToken = null;
      _storage.delete(key: _bearerTokenKey);
    } catch (error) {
      return _storage.deleteAll();
    }
  }

  Future<void> saveAuthUser({required User user}) async {
    try {
      _cachedUser = user;
      _storage.write(key: _authUserKey, value: jsonEncode(user));
    } catch (error) {
      _storage.deleteAll();
    }
  }

  Future<User?> readAuthUser() async {
    try {
      if (_cachedUser != null) {
        return _cachedUser;
      }
      final storedAuthUserJson = await _storage.read(key: _authUserKey);
      return _cachedUser = User.fromJson(jsonDecode(storedAuthUserJson!));
    } catch (error) {
      return null;
    }
  }

  Future<void> clearAuthUserStored() async {
    try {
      _cachedUser = null;
      _storage.delete(key: _authUserKey);
    } catch (error) {
      _storage.deleteAll();
    }
  }
}
