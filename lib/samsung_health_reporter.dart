import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/step_count.dart';

class SamsungHealthReporter {
  static const MethodChannel _methodChannel =
      const MethodChannel('samsung_health_reporter_method_channel');
  static const EventChannel _observeChannel =
      const EventChannel('samsung_health_reporter_event_channel_observe');

  static StreamSubscription<dynamic> observe(String constant,
      {Function(String) onUpdate}) {
    final arguments = <String, dynamic>{
      'observeType': constant,
    };
    return _observeChannel.receiveBroadcastStream(arguments).listen((event) {
      onUpdate(event);
    });
  }

  static Future<bool> authorize(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    return await _methodChannel.invokeMethod('authorize', arguments);
  }

  static Future<List<StepCount>> readSteps(
      DateTime startTime, DateTime endTime) async {
    final arguments = {
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
    };
    final result = await _methodChannel.invokeMethod('readSteps', arguments);
    final List<dynamic> list = jsonDecode(result);
    final samples = <StepCount>[];
    for (final Map<String, dynamic> map in list) {
      final sample = StepCount.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}
