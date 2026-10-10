import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/decorator/json.dart';
import 'model/decorator/platform.dart';
import 'model/decorator/subscription.dart';
import 'model/aggregate.dart';
import 'model/change_set.dart';
import 'model/device.dart';
import 'model/page.dart';
import 'model/payload/sample.dart';
import 'model/payload/user_profile.dart';
import 'model/permission.dart';
import 'model/source_filter.dart';
import 'model/time_group.dart';
import 'model/time_range.dart';
import 'model/type/aggregation.dart';
import 'model/type/health_type.dart';
import 'model/type/ordering.dart';

/// [SamsungHealthReporter] class.
/// Reads, writes and observes Samsung Health data on Android
/// through the Kotlin library SamsungHealthReporter
/// https://github.com/kvs-coder/SamsungHealthReporter.
/// Invokes calls to native side. Channel: [samsung_health_reporter_method_channel]
/// All responses are the library's JSON payloads, parsed into the models
/// of `samsung_health/model/`.
///
/// The list of Platform methods:
/// - [isAvailable]
/// - [requestPermissions]
/// - [grantedPermissions]
/// - [isAuthorized]
/// - [resolve]
/// - [localDevice]
/// - [devices]
/// - [device]
/// - [read]
/// - [readPage]
/// - [userProfile]
/// - [aggregate]
/// - [insert]
/// - [update]
/// - [delete]
/// - [deleteByUids]
/// - [deleteByClientDataIds]
/// - [changes]
/// - [observe]
///
/// Samsung Health is available only on Android: on any other platform
/// [isAvailable] returns false and every other method throws an [UnsupportedError].
/// For Apple Health on iOS see https://pub.dev/packages/health_kit_reporter.
///
/// The app needs Android 10 (API 29) or later, Samsung Health 6.30.2 or later
/// and the Samsung Health Data SDK AAR in its `android/app/libs/`.
/// Reading works in Samsung Health's developer mode;
/// writing and distributing the app need Samsung partner approval.
///
/// Timestamps are epoch milliseconds, as in the library.
/// Errors arrive as [PlatformException]s whose code is the method name,
/// whose message is the library's error message and whose details name the error:
/// `NotAuthorized`, `InvalidType`, `InvalidValue`, `Resolvable`
/// (call [resolve] to let Samsung Health fix it) or `Platform`
/// (with the SDK error code when known, e.g. `Platform(2003)`).
///
class SamsungHealthReporter {
  /// [MethodChannel] link to `SamsungHealthReporterPlugin.kt`
  ///
  static const MethodChannel _channel =
      MethodChannel('samsung_health_reporter_method_channel');

  /// The method channel, only on Android: elsewhere every method but
  /// [isAvailable] throws an [UnsupportedError].
  ///
  static MethodChannel get _methodChannel {
    requirePlatform(TargetPlatform.android, 'Samsung Health');
    return _channel;
  }

  static Map<String, dynamic> _permissionArguments(
          List<HealthType> read, List<HealthType> write) =>
      {
        'read': read.map((e) => e.identifier).toList(),
        'write': write.map((e) => e.identifier).toList(),
      };

  static Set<Permission> _permissions(String json) =>
      parseList(jsonDecode(json), Permission.fromJson).toSet();

  static Future<bool> _status(
      String method, Map<String, dynamic> arguments) async {
    return await _methodChannel.invokeMethod(method, arguments);
  }

  /// Verify whether Samsung Health is installed.
  /// Always false outside Android.
  ///
  static Future<bool> isAvailable() async {
    if (!runsOn(TargetPlatform.android)) return false;
    return await _channel.invokeMethod('isAvailable');
  }

  /// Shows the Samsung Health permission screen for the permissions
  /// not granted yet, and returns the asked-for permissions granted afterwards.
  /// Every type in [write] must be [HealthType.isWritable].
  ///
  /// Request read and write permissions separately: without Samsung partner
  /// approval every write permission request fails with `NotAuthorized`.
  ///
  static Future<Set<Permission>> requestPermissions(
      {List<HealthType> read = const [],
      List<HealthType> write = const []}) async {
    final String json = await _methodChannel.invokeMethod(
        'requestPermissions', _permissionArguments(read, write));
    return _permissions(json);
  }

  /// The asked-for permissions that are granted, without showing any screen.
  ///
  static Future<Set<Permission>> grantedPermissions(
      {List<HealthType> read = const [],
      List<HealthType> write = const []}) async {
    final String json = await _methodChannel.invokeMethod(
        'grantedPermissions', _permissionArguments(read, write));
    return _permissions(json);
  }

  /// Whether every asked-for permission is granted.
  ///
  static Future<bool> isAuthorized(
          {List<HealthType> read = const [],
          List<HealthType> write = const []}) =>
      _status('isAuthorized', _permissionArguments(read, write));

  /// Starts the fix for the last `Resolvable` error, e.g. opens the store
  /// to install or update Samsung Health.
  /// Returns false when there is none or Samsung Health offers no fix.
  ///
  static Future<bool> resolve() => _status('resolve', {});

  /// This phone as a Samsung Health device.
  ///
  static Future<Device> localDevice() async {
    final String json = await _methodChannel.invokeMethod('localDevice');
    return Device.fromJson(jsonDecode(json));
  }

  /// The user's own devices registered in Samsung Health
  /// (phone, watch, ring, accessories).
  ///
  static Future<List<Device>> devices() async {
    final String json = await _methodChannel.invokeMethod('devices');
    return parseList(jsonDecode(json), Device.fromJson);
  }

  /// The device with the [id], e.g. a [DataSource.deviceId],
  /// or null when Samsung Health doesn't know it.
  ///
  static Future<Device?> device(String id) async {
    final String? json =
        await _methodChannel.invokeMethod('device', {'id': id});
    return json == null ? null : Device.fromJson(jsonDecode(json));
  }

  /// Reads the samples of a [type] whose [HealthType.isReadable] is true
  /// in the local time [range].
  /// Newest first by default; [limit] caps the number of samples
  /// and [source] reads only the data of one source.
  ///
  static Future<List<Sample>> read(HealthType type, TimeRange range,
      {Ordering ordering = Ordering.descending,
      int? limit,
      SourceFilter? source}) async {
    final String json = await _methodChannel.invokeMethod('read', {
      'type': type.identifier,
      ...range.map,
      'ordering': ordering.value,
      if (limit != null) 'limit': limit,
      ...?source?.map,
    });
    return Sample.collect(jsonDecode(json));
  }

  /// Reads one page of the samples of a [type] in the local time [range].
  /// Pass [Page.nextPageToken] as [pageToken] for the next page.
  ///
  static Future<Page> readPage(HealthType type, TimeRange range,
      {int pageSize = 100,
      String? pageToken,
      Ordering ordering = Ordering.descending,
      SourceFilter? source}) async {
    final String json = await _methodChannel.invokeMethod('readPage', {
      'type': type.identifier,
      ...range.map,
      'pageSize': pageSize,
      if (pageToken != null) 'pageToken': pageToken,
      'ordering': ordering.value,
      ...?source?.map,
    });
    return Page.fromJson(jsonDecode(json));
  }

  /// The user's Samsung Health profile, or null when there is none.
  /// Needs the read permission of [HealthType.userProfile].
  ///
  static Future<UserProfile?> userProfile() async {
    final String? json = await _methodChannel.invokeMethod('userProfile');
    return json == null ? null : UserProfile.fromJson(jsonDecode(json));
  }

  /// Aggregates Samsung Health data in the local time [range],
  /// e.g. total steps per hour: one [Aggregate] per bucket of [group],
  /// or one for the whole range. Oldest first by default.
  /// Steps and the activity summary are only available as aggregates.
  ///
  static Future<List<Aggregate>> aggregate(
      Aggregation aggregation, TimeRange range,
      {TimeGroup? group, Ordering ordering = Ordering.ascending}) async {
    final String json = await _methodChannel.invokeMethod('aggregate', {
      'aggregation': aggregation.value,
      ...range.map,
      if (group != null) 'groupUnit': group.unit.value,
      if (group != null) 'groupMultiplier': group.multiplier,
      'ordering': ordering.value,
    });
    return parseList(jsonDecode(json), Aggregate.fromJson);
  }

  /// Inserts [samples] of one or more types and returns them as inserted:
  /// a sample without a client data id gets a random UUID,
  /// so it can be updated or deleted without reading it back.
  /// Writes of one type are atomic.
  ///
  static Future<List<WritableSample>> insert(
      List<WritableSample> samples) async {
    final String json = await _methodChannel.invokeMethod(
        'insert', {'samples': samples.map((e) => e.map).toList()});
    return Sample.collect(jsonDecode(json)).cast<WritableSample>();
  }

  /// Replaces stored samples the app inserted,
  /// found by their uid or, without one, by their client data id.
  ///
  static Future<bool> update(List<WritableSample> samples) =>
      _status('update', {'samples': samples.map((e) => e.map).toList()});

  /// Deletes a stored [sample] the app inserted,
  /// found by its uid or, without one, by its client data id.
  ///
  static Future<bool> delete(Sample sample) =>
      _status('delete', {'sample': sample.map});

  /// Deletes stored data points of a writable [type] by their [uids].
  ///
  static Future<bool> deleteByUids(HealthType type, List<String> uids) =>
      _status('deleteByUids', {'type': type.identifier, 'uids': uids});

  /// Deletes stored data points of a writable [type] by their [clientDataIds].
  ///
  static Future<bool> deleteByClientDataIds(
          HealthType type, List<String> clientDataIds) =>
      _status('deleteByClientDataIds',
          {'type': type.identifier, 'clientDataIds': clientDataIds});

  /// The changes of an observable [type] between [since] and [until]
  /// (epoch milliseconds; now by default).
  /// Persist [ChangeSet.until] and pass it as [since] to the next call.
  ///
  static Future<ChangeSet> changes(HealthType type, int since,
      {int? until}) async {
    final String json = await _methodChannel.invokeMethod('changes', {
      'type': type.identifier,
      'since': since,
      if (until != null) 'until': until,
    });
    return ChangeSet.fromJson(jsonDecode(json));
  }

  /// Polls the changes of an observable [type] every [interval]
  /// from [since] (epoch milliseconds) while subscribed, and calls [onUpdate]
  /// with every non-empty [ChangeSet].
  /// Every subscription polls on an [EventChannel] of its own;
  /// cancel it to stop polling. Errors end polling and reach [onError].
  ///
  static StreamSubscription<dynamic> observe(HealthType type, int since,
      {Duration interval = const Duration(minutes: 1),
      required void Function(ChangeSet changeSet) onUpdate,
      Function? onError}) {
    return subscribe<ChangeSet>(
        _methodChannel,
        'observe',
        {
          'type': type.identifier,
          'since': since,
          'interval': interval.inMilliseconds,
        },
        (event) => ChangeSet.fromJson(jsonDecode(event)),
        onUpdate,
        onError);
  }
}
