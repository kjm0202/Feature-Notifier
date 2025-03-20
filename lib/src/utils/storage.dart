import 'package:shared_preferences/shared_preferences.dart';

class FeatureNotifierStorage {
  static Future<void> write({required bool value, required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isViewed/$id", value);
  }

  static Future<bool> read(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isViewed/$id") ?? false;
  }

  static Future<void> erase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isViewed/$id", false);
  }

  static Future<void> eraseAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith("isViewed/")) {
        await prefs.setBool(key, false);
      }
    }
  }
}
