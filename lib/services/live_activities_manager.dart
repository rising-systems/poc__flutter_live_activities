import 'package:shared_preferences/shared_preferences.dart';

class LiveActivitiesManager {
  static const String _key = 'live_activities';
  static SharedPreferencesAsync? _prefs;

  LiveActivitiesManager._internal();

  static Future<void> init() async {
    _prefs ??= SharedPreferencesAsync();
  }

  static Future<void> save(String? activitiesKey) async {
    if (activitiesKey == null || _prefs == null) return;
    await _prefs!.setString(_key, activitiesKey);
  }

  static Future<String?> load() async {
    return await _prefs?.getString(_key);
  }

  static Future<void> clear() async {
    if (_prefs == null) return;
    await _prefs!.remove(_key);
  }
}
