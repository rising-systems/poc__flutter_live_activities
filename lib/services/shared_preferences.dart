// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// /// Creates an instance of the [SharedPreferenceHelper] class and assigns it to a variable called sharedPreference.
// final sharedPreference = SharedPreferenceHelper();

// class SharedPreferenceHelper {
//   late SharedPreferences _sharedPreference;

//   /// A method that initializes the `SharedPreferences` instance.
//   void initSharedPreferences() async {
//     _sharedPreference = await SharedPreferences.getInstance();
//   }

//   /// A getter that returns the `_sharedPreference` instance.
//   SharedPreferences get prefs => _sharedPreference;

//   /// A method that clears all values in the `_sharedPreference` instance.
//   Future<void> clearAll() async {
//     await _sharedPreference.clear();
//   }

//   /// A method that saves a key-value pair in the `_sharedPreference` instance.
//   Future<void> saveData(String key, dynamic value) async {
//     if (value is String) {
//       await _sharedPreference.setString(key, value);
//     } else if (value is int) {
//       await _sharedPreference.setInt(key, value);
//     } else if (value is double) {
//       await _sharedPreference.setDouble(key, value);
//     } else if (value is bool) {
//       await _sharedPreference.setBool(key, value);
//     } else if (value is List<String>) {
//       await _sharedPreference.setStringList(key, value);
//     } else {
//       await _sharedPreference.setString(key, json.encode(value));
//     }
//   }

//   /// A method that retrieves a value from the `_sharedPreference` instance.
//   T? getData<T>(String key) {
//     if (T == String) {
//       return _sharedPreference.getString(key) as T;
//     } else if (T == int) {
//       return _sharedPreference.getInt(key) as T;
//     } else if (T == double) {
//       return _sharedPreference.getDouble(key) as T;
//     } else if (T == bool) {
//       return _sharedPreference.getBool(key) as T;
//     } else if (T == List<String>) {
//       return _sharedPreference.getStringList(key) as T;
//     } else {
//       return json.decode(_sharedPreference.getString(key)!) as T;
//     }
//   }
// }
