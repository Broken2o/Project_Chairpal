import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveRememberToken(String token);
  Future<String?> getRememberToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _rememberTokenKey = 'remember_token';
  static const String _userKey = 'user_data';
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> saveRememberToken(String token) async {
    await _sharedPreferences.setString(_rememberTokenKey, token);
  }

  @override
  Future<String?> getRememberToken() async {
    return _sharedPreferences.getString(_rememberTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await _sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final String? userJson = _sharedPreferences.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @override
  Future<void> clearTokens() async {
    await _sharedPreferences.remove(_tokenKey);
    await _sharedPreferences.remove(_rememberTokenKey);
    await _sharedPreferences.remove(_userKey);
  }
}
