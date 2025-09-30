import 'dart:convert';

import 'package:ecommerce/src/home/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void _checkInit() {
    if (_prefs == null) {
      throw Exception(
          "SharedPrefs not initialized. Call SharedPrefs.init() in main() before using it.");
    }
  }

  /// Save String
  static Future<bool> setString(String key, String value) async {
    _checkInit();
    return await _prefs!.setString(key, value);
  }

  /// Get String
  static String? getString(String key) {
    _checkInit();
    return _prefs!.getString(key);
  }

  /// Save Int
  static Future<bool> setInt(String key, int value) async {
    _checkInit();
    return await _prefs!.setInt(key, value);
  }

  /// Get Int
  static int? getInt(String key) {
    _checkInit();
    return _prefs!.getInt(key);
  }

  /// Save Bool
  static Future<bool> setBool(String key, bool value) async {
    _checkInit();
    return await _prefs!.setBool(key, value);
  }

  /// Get Bool
  static bool? getBool(String key) {
    _checkInit();
    return _prefs!.getBool(key);
  }

  /// Save Double
  static Future<bool> setDouble(String key, double value) async {
    _checkInit();
    return await _prefs!.setDouble(key, value);
  }

  /// Get Double
  static double? getDouble(String key) {
    _checkInit();
    return _prefs!.getDouble(key);
  }

  /// Save List<String>
  static Future<bool> setStringList(String key, List<String> value) async {
    _checkInit();
    return await _prefs!.setStringList(key, value);
  }

  /// Get List<String>
  static List<String>? getStringList(String key) {
    _checkInit();
    return _prefs!.getStringList(key);
  }

  /// Remove specific key
  static Future<bool> remove(String key) async {
    _checkInit();
    return await _prefs!.remove(key);
  }

  /// Clear all data
  static Future<bool> clear() async {
    _checkInit();
    return await _prefs!.clear();
  }

  static List<ApiUser>? getUser() {
    _checkInit();
    final userJson = _prefs!.getString(PrefsKeys.user);
    if (userJson != null) {
      return (json.decode(userJson) as List)
          .map((user) => ApiUser.fromMap(user))
          .toList();
    }
    return null;
  }

  static Future<bool> setUser(List<ApiUser> user) async {
    _checkInit();
    final userJson = json.encode(user.map((u) => u.toMap()).toList());
    return await _prefs!.setString(PrefsKeys.user, userJson);
  }
}

class PrefsKeys {
  static const String token = 'token';
  static const String user = 'user';
  static const String theme = 'theme';
  static const String languageCode = 'language_code';
  static const String isLoggedIn = 'is_logged_in';
  static const String firstTimer = 'first_timer';
}
