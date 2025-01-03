import 'dart:async';

import 'package:background_task/background_task.dart';
import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/models/location_data.dart';
import 'package:live_activities_example/services/live_activities_manager.dart';
import 'package:live_activities_example/widgets/buttons/stop.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  StreamSubscription<UrlSchemeData>? urlSchemeSubscription;

  @override
  void initState() {
    super.initState();

    _liveActivitiesPlugin.init(
      appGroupId: 'group.pa-png-test.liveactivities',
    );

    _liveActivitiesPlugin.activityUpdateStream.listen((event) {
      LiveActivitiesManager.save(event.activityId);
    });
  }

  @override
  void dispose() {
    urlSchemeSubscription?.cancel();
    _liveActivitiesPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Activities (Flutter)',
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_latestActivityId == null) ...[
                ElevatedButton(
                  child: const Text('Start '),
                  onPressed: () async {
                    await requestLocationPermissions(context);
                    setState(() {});
                  },
                ),
              ],
              if (_latestActivityId != null)
                StopButton(
                  onPressed: () async {
                    _liveActivitiesPlugin.endAllActivities();
                    _latestActivityId = null;
                    await BackgroundTask.instance.stop();
                    await LiveActivitiesManager.clear();
                    setState(() {});
                  },
                ),
              const Spacer(),
              FutureBuilder(
                future: BackgroundTask.instance.isRunning,
                builder: (context, data) {
                  return Text('Is running in background: ${data.data}');
                },
              ),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestLocationPermissions(BuildContext context) async {
    await Permission.locationWhenInUse.request();

    if (await Permission.locationWhenInUse.isGranted) {
      final initiallyStatus = await Permission.locationAlways.status;
      if (!context.mounted) return;

      if (initiallyStatus.isGranted) {
        await _startTracking();
        setState(() {});

        if (!context.mounted) return;

        return;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Location permission granted'),
              content: const Text('Now, can you please grant the always location permission?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await openAppSettings();
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Location permission denied'),
            content: const Text('You need to grant the location permission to start tracking your location'),
            actions: [
              TextButton(
                onPressed: () async {
                  final result = await openAppSettings();
                  if (!result) return;
                  final always = await Permission.locationAlways.status;
                  if (always.isGranted) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Location permission granted'),
                          content: const Text('You can now start tracking your location'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await _startTracking();
                                setState(() {});

                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                              child: const Text('Start tracking'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _startTracking() async {
    final model = UserData(
      name: 'Name',
      lat: 0,
      lng: 0,
      lastCheckTime: DateTime.now(),
      lastUpdateDateTime: DateTime.now(),
      status: '0',
      message: 'Unknown',
      latestActivityId: '',
    );

    final activityId = await _liveActivitiesPlugin.createActivity(
      model.toMap(),
    );

    await LiveActivitiesManager.save(activityId);

    await BackgroundTask.instance.start(
      isEnabledEvenIfKilled: true,
    );

    setState(() => _latestActivityId = activityId);
  }
}
