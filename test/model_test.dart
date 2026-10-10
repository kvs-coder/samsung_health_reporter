import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/exceptions.dart';
import 'package:samsung_health_reporter/model/aggregate.dart';
import 'package:samsung_health_reporter/model/change_set.dart';
import 'package:samsung_health_reporter/model/data_source.dart';
import 'package:samsung_health_reporter/model/device.dart';
import 'package:samsung_health_reporter/model/page.dart';
import 'package:samsung_health_reporter/model/payload/blood_pressure.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/payload/sleep.dart';
import 'package:samsung_health_reporter/model/permission.dart';
import 'package:samsung_health_reporter/model/source_filter.dart';
import 'package:samsung_health_reporter/model/time_group.dart';
import 'package:samsung_health_reporter/model/time_range.dart';
import 'package:samsung_health_reporter/model/type/access_type.dart';
import 'package:samsung_health_reporter/model/type/aggregation.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/model/type/time_group_unit.dart';

import 'fixtures.dart' as fixtures;

void main() {
  group('TimeRange', () {
    test('time_range_maps_start_and_end', () {
      final sut = TimeRange(start: fixtures.start, end: fixtures.end);
      expect(sut.map, {'start': fixtures.start, 'end': fixtures.end});
      expect(TimeRange.fromJson(sut.map), sut);
    });

    test('time_range_from_dates_holds_epoch_milliseconds', () {
      final sut = TimeRange.fromDates(
        DateTime.fromMillisecondsSinceEpoch(fixtures.start),
        DateTime.fromMillisecondsSinceEpoch(fixtures.end),
      );
      expect(sut.start, fixtures.start);
      expect(sut.end, fixtures.end);
    });

    test('time_range_throws_when_end_is_not_after_start', () {
      expect(() => TimeRange(start: fixtures.start, end: fixtures.start),
          throwsA(isA<InvalidValueException>()));
      expect(() => TimeRange(start: fixtures.end, end: fixtures.start),
          throwsA(isA<InvalidValueException>()));
    });
  });

  group('TimeGroup', () {
    test('time_group_multiplier_is_one_by_default', () {
      final sut = TimeGroup(unit: TimeGroupUnit.daily);
      expect(sut.multiplier, 1);
      expect(sut.map, {'unit': 'DAILY', 'multiplier': 1});
      expect(TimeGroup.fromJson({'unit': 'DAILY'}), sut);
    });

    test('time_group_round_trips', () {
      final sut = TimeGroup(unit: TimeGroupUnit.minutely, multiplier: 15);
      expect(TimeGroup.fromJson(sut.map), sut);
    });

    test('time_group_throws_for_a_multiplier_below_one', () {
      expect(() => TimeGroup(unit: TimeGroupUnit.hourly, multiplier: 0),
          throwsA(isA<InvalidValueException>()));
    });
  });

  group('SourceFilter', () {
    test('source_filter_maps_every_source', () {
      expect(const SourceFilter.app('com.example').map,
          {'source': 'app', 'appId': 'com.example'});
      expect(SourceFilter.localDevice.map, {'source': 'localDevice'});
      expect(SourceFilter.samsungHealth.map, {'source': 'samsungHealth'});
    });

    test('source_filter_round_trips', () {
      for (final sut in [
        const SourceFilter.app('com.example'),
        SourceFilter.localDevice,
        SourceFilter.samsungHealth,
      ]) {
        expect(SourceFilter.fromJson(sut.map), sut);
      }
      expect(const SourceFilter.app('a'), isNot(const SourceFilter.app('b')));
    });

    test('source_filter_throws_for_an_unknown_source', () {
      expect(() => SourceFilter.fromJson({'source': 'cloud'}),
          throwsA(isA<InvalidValueException>()));
    });
  });

  group('Permission', () {
    test('permissions_parse_type_by_enum_name', () {
      final sut = Permission.collect(fixtures.permissions);
      expect(sut, const [
        Permission(type: HealthType.heartRate, access: AccessType.read),
        Permission(type: HealthType.exerciseLocation, access: AccessType.read),
        Permission(type: HealthType.sleep, access: AccessType.write),
      ]);
      expect(sut.map((e) => e.map).toList(), fixtures.permissions);
    });

    test('permission_throws_for_an_identifier_instead_of_a_name', () {
      expect(
          () => Permission.fromJson({'type': 'heart_rate', 'access': 'READ'}),
          throwsA(isA<InvalidValueException>()));
    });
  });

  group('Device', () {
    test('device_parses_every_field_and_round_trips', () {
      final sut = Device.fromJson(fixtures.device);
      expect(sut.id, 'device-1');
      expect(sut.type, 'WATCH');
      expect(sut.manufacturer, 'Samsung');
      expect(sut.model, 'SM-R960');
      expect(sut.name, 'Galaxy Watch');
      expect(sut.map, fixtures.device);
      expect(Device.fromJson(sut.map), sut);
    });

    test('device_minimal_json_parses', () {
      final sut = Device.collect([
        {'id': 'device-2', 'type': 'MOBILE'},
      ]).single;
      expect(sut, const Device(id: 'device-2', type: 'MOBILE'));
      expect(sut.name, isNull);
    });
  });

  test('data_source_round_trips', () {
    final sut = DataSource.fromJson(fixtures.dataSource);
    expect(sut.map, fixtures.dataSource);
    expect(DataSource.tryFromJson(null), isNull);
    expect(DataSource.tryFromJson(sut.map), sut);
  });

  group('Aggregate', () {
    test('aggregate_parses_every_field_and_round_trips', () {
      final sut = Aggregate.fromJson(fixtures.aggregate);
      expect(sut.aggregation, Aggregation.stepsTotal);
      expect(sut.startTimestamp, fixtures.start);
      expect(sut.endTimestamp, fixtures.end);
      expect(sut.value, 1234.0);
      expect(sut.unit, 'count');
      expect(sut.map, fixtures.aggregate);
      expect(Aggregate.fromJson(sut.map), sut);
    });

    test('aggregate_without_data_or_unit_parses', () {
      final sut = Aggregate.collect([
        {
          'aggregation': 'HEART_RATE_MAX',
          'startTimestamp': fixtures.start,
          'endTimestamp': fixtures.end,
        },
      ]).single;
      expect(sut.value, isNull);
      expect(sut.unit, 'bpm');
    });
  });

  group('ChangeSet', () {
    test('change_set_parses_every_field', () {
      final sut = ChangeSet.fromJson(fixtures.changeSet);
      expect(sut.type, HealthType.heartRate);
      expect(sut.since, fixtures.start);
      expect(sut.until, fixtures.end);
      expect(
          sut.upserted.map((e) => e.runtimeType), [HeartRate, BloodPressure]);
      expect(sut.deletedUids, ['uid-deleted-1', 'uid-deleted-2']);
      expect(sut.isEmpty, isFalse);
    });

    test('change_set_round_trips', () {
      final sut = ChangeSet.fromJson(fixtures.changeSet);
      expect(sut.map['type'], 'HEART_RATE');
      expect(ChangeSet.fromJson(sut.map), sut);
    });

    test('change_set_without_changes_is_empty', () {
      final sut = ChangeSet.fromJson({
        'type': 'SLEEP',
        'since': fixtures.start,
        'until': fixtures.end,
        'upserted': <dynamic>[],
        'deletedUids': <dynamic>[],
      });
      expect(sut.isEmpty, isTrue);
    });
  });

  group('Page', () {
    test('page_parses_items_and_token', () {
      final sut = Page.fromJson(fixtures.page);
      expect(sut.items.map((e) => e.runtimeType), [HeartRate, Sleep]);
      expect(sut.nextPageToken, 'token-2');
      expect(Page.fromJson(sut.map), sut);
    });

    test('last_page_has_no_token', () {
      final sut = Page.fromJson({'items': <dynamic>[]});
      expect(sut.items, isEmpty);
      expect(sut.nextPageToken, isNull);
    });
  });
}
