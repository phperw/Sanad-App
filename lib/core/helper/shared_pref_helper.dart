import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static late SharedPreferences sharedPreferences;

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return false;
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearAll() async {
    return await sharedPreferences.clear();
  }

  // ── Token helpers ──────────────────────────────────────────
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await setData(key: keyAccessToken, value: accessToken);
    await setData(key: keyRefreshToken, value: refreshToken);
  }

  static String? getAccessToken() => getData(key: keyAccessToken) as String?;

  static String? getRefreshToken() => getData(key: keyRefreshToken) as String?;

  static Future<void> clearTokens() async {
    await removeData(key: keyAccessToken);
    await removeData(key: keyRefreshToken);
  }

  static bool hasToken() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
