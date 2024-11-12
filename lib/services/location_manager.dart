import 'dart:convert';
import 'package:live_activities_example/models/location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationDataService {
  static const String _locationDataKey = 'location_data';

  Future<void> save(UserData locationData) async {
    final prefs = await SharedPreferences.getInstance();
    final locationDataJson = jsonEncode(locationData.toMap());
    await prefs.setString(_locationDataKey, locationDataJson);
  }

  Future<UserData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final locationDataJson = prefs.getString(_locationDataKey);
    if (locationDataJson == null) return null;

    final Map<String, dynamic> locationDataMap = jsonDecode(locationDataJson);
    return UserData.fromMap(locationDataMap);
  }
}
