import 'dart:developer';
import 'dart:math' as math;

import 'package:background_task/background_task.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities_example/models/location_data.dart';
import 'package:live_activities_example/services/live_activities_manager.dart';
import 'package:live_activities_example/services/location_manager.dart';
import 'package:live_activities_example/widgets/home_page.dart';

@pragma('vm:entry-point')
void backgroundHandler(Location location) async {
  final service = LocationDataService();
  LiveActivitiesManager.init();

  final plugin = LiveActivities();
  plugin.init(appGroupId: 'group.dimitridessus.liveactivities');

  final liveActivitiesID = await LiveActivitiesManager.load();

  if (liveActivitiesID == null) {
    log('No live activities found');
    return;
  } else {
    final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

    var lastCheckTime = (await service.load())?.lastCheckTime ??
        DateTime.now().subtract(
          const Duration(seconds: 7),
        );

    final now = DateTime.now();

    if (now.difference(lastCheckTime).inSeconds >= 5) {
      lastCheckTime = now;

      final response = await dio.get('/users/${math.Random().nextInt(10) + 1}');

      await service.save(UserData.fromLocation(
        location,
        name: response.data['name'],
        status: response.statusCode.toString(),
        message: response.statusMessage ?? 'Unknown',
        lastCheckTime: lastCheckTime,
        latestActivityId: liveActivitiesID,
      ));

      final data = await service.load();
      if (await plugin.areActivitiesEnabled()) {
        plugin.updateActivity(liveActivitiesID, data?.toMap() ?? {});
        log('Data: ${data?.toMap()}');
      } else {}
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LiveActivitiesManager.init();
  BackgroundTask.instance.setBackgroundHandler(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
