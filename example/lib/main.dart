import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samsung_health_reporter/samsung_health_reporter.dart';
import 'package:samsung_health_reporter/session_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final opened = await SamsungHealthReporter.openConnection();
      print('opened: $opened');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('SH'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            runSamsungHealthReporter();
          },
        ),
      ),
    );
  }

  Future<void> runSamsungHealthReporter() async {
    try {
      final readTypes = <String>[];
      readTypes.add(SessionType.stepCount.constant);
      final writeTypes = <String>[];
      writeTypes.add(SessionType.stepCount.constant);
      final isAuthorized =
          await SamsungHealthReporter.authorize(readTypes, writeTypes);
      if (isAuthorized) {
        print('isAuthorized: $isAuthorized');
        final startTime = DateTime.utc(2020, 1, 1, 12, 30, 30);
        final endTime = DateTime.utc(2020, 12, 31, 12, 30, 30);
        final steps = await SamsungHealthReporter.readSteps(startTime, endTime);
        steps.forEach((e) {
          print('steps: ${e.map}');
        });
      } else {
        print('isAuthorized failed');
      }
    } catch (exception) {
      print('general exception: $exception');
    } finally {
      print('SamsungHealthReporter is done');
    }
  }
}
