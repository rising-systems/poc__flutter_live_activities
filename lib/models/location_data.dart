import 'package:background_task/background_task.dart';

class UserData {
  final String name;
  final double lat;
  final double lng;
  final DateTime lastUpdateDateTime;
  final DateTime lastCheckTime;
  final String status;
  final String message;
  final String latestActivityId;

  UserData({
    required this.name,
    required this.lat,
    required this.lng,
    required this.lastUpdateDateTime,
    required this.lastCheckTime,
    required this.status,
    required this.message,
    required this.latestActivityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'lastCheckTime': lastCheckTime.toIso8601String(),
      'lastUpdateDateTime': lastUpdateDateTime.toIso8601String(),
      'status': status,
      'message': message,
      'latestActivityId': latestActivityId,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      lat: map['lat'],
      lng: map['lng'],
      lastCheckTime: DateTime.parse(map['lastCheckTime']),
      lastUpdateDateTime: DateTime.parse(map['lastUpdateDateTime']),
      status: map['status'],
      message: map['message'],
      latestActivityId: map['latestActivityId'] ?? '',
    );
  }

  factory UserData.fromLocation(
    Location location, {
    required String name,
    required String status,
    required String message,
    required String latestActivityId,
    DateTime? lastCheckTime,
  }) {
    return UserData(
      name: name,
      lat: location.lat ?? 0,
      lng: location.lng ?? 0,
      lastCheckTime: lastCheckTime ?? DateTime.now(),
      lastUpdateDateTime: DateTime.now(),
      status: status,
      message: message,
      latestActivityId: latestActivityId,
    );
  }
}
