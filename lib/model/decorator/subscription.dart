import 'dart:async';

import 'package:flutter/services.dart';

/// Starts a live subscription: the native side checks the arguments of [method]
/// and replies with the name of an [EventChannel] of its own,
/// so every subscription runs and stops independently.
/// Listening to the channel starts the native work, cancelling stops it.
/// Failures, also while planning, reach [onError] as [PlatformException]s
/// whose code is [method]; so do events [parse] can't read.
///
StreamSubscription<dynamic> subscribe<T>(
    MethodChannel channel,
    String method,
    Map<String, dynamic> arguments,
    T Function(dynamic event) parse,
    void Function(T update) onUpdate,
    Function? onError) {
  StreamSubscription<dynamic>? events;
  var cancelled = false;
  late final StreamController<T> controller;
  controller = StreamController<T>(
    onListen: () async {
      try {
        final String name = await channel.invokeMethod(method, arguments);
        // Listening and cancelling releases the native work
        // of a subscription cancelled while it was planned
        events = EventChannel(name).receiveBroadcastStream().listen((event) {
          try {
            controller.add(parse(event));
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
          }
        }, onError: controller.addError);
        if (cancelled) await events?.cancel();
      } catch (error, stackTrace) {
        controller.addError(error, stackTrace);
      }
    },
    onCancel: () async {
      cancelled = true;
      await events?.cancel();
    },
  );
  return controller.stream.listen(onUpdate, onError: onError);
}
