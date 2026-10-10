import 'dart:convert';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/change_set.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/payload/skin_temperature.dart';
import 'package:samsung_health_reporter/model/source_filter.dart';
import 'package:samsung_health_reporter/model/time_group.dart';
import 'package:samsung_health_reporter/model/time_range.dart';
import 'package:samsung_health_reporter/model/type/access_type.dart';
import 'package:samsung_health_reporter/model/type/aggregation.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/model/type/ordering.dart';
import 'package:samsung_health_reporter/model/type/time_group_unit.dart';
import 'package:samsung_health_reporter/samsung_health_reporter.dart';

import 'fixtures.dart' as fixtures;

/// Every method sends the arguments the Kotlin dispatcher reads
/// and parses the reply it sends.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Samsung Health runs only on Android
  setUpAll(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);
  tearDownAll(() => debugDefaultTargetPlatformOverride = null);

  const channel = MethodChannel('samsung_health_reporter_method_channel');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <String, dynamic>{};
  final replies = <String, Object?>{};
  final range = TimeRange(start: fixtures.start, end: fixtures.end);
  final heartRate = HeartRate.fromJson(fixtures.heartRate);

  setUp(() {
    calls.clear();
    replies.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls[call.method] = call.arguments;
      final reply = replies[call.method];
      if (reply is PlatformException) throw reply;
      return reply;
    });
  });
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('is_available_replies_the_check', () async {
    replies['isAvailable'] = true;

    expect(await SamsungHealthReporter.isAvailable(), isTrue);
  });

  group('manager', () {
    test('request_permissions_sends_identifiers_and_parses_permissions',
        () async {
      replies['requestPermissions'] = jsonEncode(fixtures.permissions);

      final sut = await SamsungHealthReporter.requestPermissions(
          read: [HealthType.heartRate, HealthType.steps],
          write: [HealthType.heartRate]);

      expect(calls['requestPermissions'], {
        'read': ['heart_rate', 'steps'],
        'write': ['heart_rate'],
      });
      expect(sut.map((e) => (e.type, e.access)),
          contains((HealthType.heartRate, AccessType.read)));
    });

    test('granted_permissions_and_is_authorized_default_to_no_types', () async {
      replies['grantedPermissions'] = '[]';
      replies['isAuthorized'] = false;

      expect(await SamsungHealthReporter.grantedPermissions(), isEmpty);
      expect(await SamsungHealthReporter.isAuthorized(read: [HealthType.sleep]),
          isFalse);
      expect(calls['grantedPermissions'], {'read': [], 'write': []});
      expect(calls['isAuthorized'], {
        'read': ['sleep'],
        'write': [],
      });
    });

    test('resolve_replies_whether_a_fix_started', () async {
      replies['resolve'] = true;

      expect(await SamsungHealthReporter.resolve(), isTrue);
    });

    test('devices_parse_their_json', () async {
      replies['localDevice'] = jsonEncode(fixtures.device);
      replies['devices'] = jsonEncode([fixtures.device]);
      replies['device'] = jsonEncode(fixtures.device);

      expect((await SamsungHealthReporter.localDevice()).id,
          fixtures.device['id']);
      expect(await SamsungHealthReporter.devices(), hasLength(1));
      expect((await SamsungHealthReporter.device('device-1'))?.id,
          fixtures.device['id']);
      expect(calls['device'], {'id': 'device-1'});
    });

    test('an_unknown_device_is_null', () async {
      replies['device'] = null;

      expect(await SamsungHealthReporter.device('watch'), isNull);
    });
  });

  group('reader', () {
    test('read_sends_every_argument_and_parses_mixed_samples', () async {
      replies['read'] =
          jsonEncode([fixtures.heartRate, fixtures.skinTemperature]);

      final sut = await SamsungHealthReporter.read(HealthType.heartRate, range,
          ordering: Ordering.ascending,
          limit: 10,
          source: SourceFilter.app('com.example'));

      expect(calls['read'], {
        'type': 'heart_rate',
        'start': fixtures.start,
        'end': fixtures.end,
        'ordering': 'ASCENDING',
        'limit': 10,
        'source': 'app',
        'appId': 'com.example',
      });
      expect(sut.first, heartRate);
      expect(sut.last, isA<SkinTemperature>());
    });

    test('read_defaults_to_newest_first_from_every_source', () async {
      replies['read'] = '[]';

      await SamsungHealthReporter.read(HealthType.sleep, range);

      expect(calls['read'], {
        'type': 'sleep',
        'start': fixtures.start,
        'end': fixtures.end,
        'ordering': 'DESCENDING',
      });
    });

    test('read_page_sends_the_token_and_parses_the_next_one', () async {
      replies['readPage'] = jsonEncode(fixtures.page);

      final sut = await SamsungHealthReporter.readPage(
          HealthType.heartRate, range,
          pageSize: 5, pageToken: 'token', source: SourceFilter.localDevice);

      expect(calls['readPage'], {
        'type': 'heart_rate',
        'start': fixtures.start,
        'end': fixtures.end,
        'pageSize': 5,
        'pageToken': 'token',
        'ordering': 'DESCENDING',
        'source': 'localDevice',
      });
      expect(sut.nextPageToken, fixtures.page['nextPageToken']);
      expect(sut.items, isNotEmpty);
    });

    test('user_profile_parses_or_is_null', () async {
      replies['userProfile'] = jsonEncode(fixtures.userProfile);
      expect((await SamsungHealthReporter.userProfile())?.nickname,
          fixtures.userProfile['nickname']);

      replies['userProfile'] = null;
      expect(await SamsungHealthReporter.userProfile(), isNull);
    });

    test('aggregate_sends_the_group_and_defaults_to_oldest_first', () async {
      replies['aggregate'] = jsonEncode([fixtures.aggregate]);

      final sut = await SamsungHealthReporter.aggregate(
          Aggregation.stepsTotal, range,
          group: TimeGroup(unit: TimeGroupUnit.hourly, multiplier: 2));

      expect(calls['aggregate'], {
        'aggregation': 'STEPS_TOTAL',
        'start': fixtures.start,
        'end': fixtures.end,
        'groupUnit': 'HOURLY',
        'groupMultiplier': 2,
        'ordering': 'ASCENDING',
      });
      expect(sut, hasLength(1));
    });

    test('aggregate_without_group_sends_no_group', () async {
      replies['aggregate'] = '[]';

      await SamsungHealthReporter.aggregate(
          Aggregation.sleepTotalDuration, range,
          ordering: Ordering.descending);

      expect(calls['aggregate'], {
        'aggregation': 'SLEEP_TOTAL_DURATION',
        'start': fixtures.start,
        'end': fixtures.end,
        'ordering': 'DESCENDING',
      });
    });
  });

  group('writer', () {
    test('insert_sends_sample_maps_and_parses_the_inserted_ones', () async {
      replies['insert'] = jsonEncode([fixtures.heartRate]);
      const sample = HeartRate(
          startTimestamp: fixtures.start,
          endTimestamp: fixtures.end,
          harmonized: HeartRateHarmonized(heartRate: 72));

      final sut = await SamsungHealthReporter.insert([sample]);

      expect(calls['insert'], {
        'samples': [sample.map]
      });
      expect((calls['insert']['samples'] as List).single['type'], 'heart_rate');
      expect(sut.single, heartRate);
    });

    test('update_and_deletes_send_samples_and_ids', () async {
      for (final method in [
        'update',
        'delete',
        'deleteByUids',
        'deleteByClientDataIds'
      ]) {
        replies[method] = true;
      }

      expect(await SamsungHealthReporter.update([heartRate]), isTrue);
      expect(await SamsungHealthReporter.delete(heartRate), isTrue);
      expect(
          await SamsungHealthReporter.deleteByUids(
              HealthType.heartRate, ['uid']),
          isTrue);
      expect(
          await SamsungHealthReporter.deleteByClientDataIds(
              HealthType.waterIntake, ['id']),
          isTrue);
      expect(calls['update'], {
        'samples': [heartRate.map]
      });
      expect(calls['delete'], {'sample': heartRate.map});
      expect(calls['deleteByUids'], {
        'type': 'heart_rate',
        'uids': ['uid']
      });
      expect(calls['deleteByClientDataIds'], {
        'type': 'water_intake',
        'clientDataIds': ['id']
      });
    });
  });

  group('observer', () {
    test('changes_send_the_window_and_parse_the_change_set', () async {
      replies['changes'] = jsonEncode(fixtures.changeSet);

      final sut =
          await SamsungHealthReporter.changes(HealthType.sleep, 1, until: 2);

      expect(calls['changes'], {'type': 'sleep', 'since': 1, 'until': 2});
      expect(sut, ChangeSet.fromJson(fixtures.changeSet));
    });

    test('changes_until_now_send_no_until', () async {
      replies['changes'] = jsonEncode(fixtures.changeSet);

      await SamsungHealthReporter.changes(HealthType.sleep, 1);

      expect(calls['changes'], {'type': 'sleep', 'since': 1});
    });

    test('observe_listens_to_its_channel_and_reports_change_sets_and_errors',
        () async {
      const name = 'samsung_health_reporter_event_channel_observe_1';
      final cancelled = <String>[];
      replies['observe'] = name;
      messenger.setMockStreamHandler(
          const EventChannel(name),
          MockStreamHandler.inline(
              onListen: (arguments, sink) {
                sink.success(jsonEncode(fixtures.changeSet));
                sink.error(code: 'observe', message: 'No permission');
              },
              onCancel: (_) => cancelled.add(name)));
      final updates = <ChangeSet>[];
      final errors = <Object>[];

      final sut = SamsungHealthReporter.observe(HealthType.heartRate, 1,
          interval: const Duration(seconds: 30),
          onUpdate: updates.add,
          onError: errors.add);
      await pumpEventQueue();
      await sut.cancel();

      expect(calls['observe'],
          {'type': 'heart_rate', 'since': 1, 'interval': 30000});
      expect(updates.single, ChangeSet.fromJson(fixtures.changeSet));
      expect(errors.single,
          isA<PlatformException>().having((e) => e.code, 'code', 'observe'));
      expect(cancelled, [name]);
      messenger.setMockStreamHandler(const EventChannel(name), null);
    });

    test('observe_failing_its_call_reports_the_error', () async {
      replies['observe'] = PlatformException(
          code: 'observe',
          message: 'steps is not observable',
          details: 'InvalidType');
      final errors = <Object>[];

      final sut = SamsungHealthReporter.observe(HealthType.steps, 1,
          onUpdate: (_) {}, onError: errors.add);
      await pumpEventQueue();
      await sut.cancel();

      expect(
          calls['observe'], {'type': 'steps', 'since': 1, 'interval': 60000});
      expect(
          errors.single,
          isA<PlatformException>()
              .having((e) => e.details, 'details', 'InvalidType'));
    });
  });

  test('errors_keep_code_message_and_kind', () async {
    replies['localDevice'] = PlatformException(
        code: 'localDevice',
        message: 'No permission',
        details: 'NotAuthorized');

    expect(
        SamsungHealthReporter.localDevice(),
        throwsA(isA<PlatformException>()
            .having((e) => e.code, 'code', 'localDevice')
            .having((e) => e.details, 'details', 'NotAuthorized')));
  });

  test('sample_maps_read_back_into_the_same_sample', () {
    for (final json in fixtures.samples.values) {
      final sut = Sample.factory(json);
      expect(Sample.factory(jsonDecode(jsonEncode(sut.map))), sut);
    }
  });
}
