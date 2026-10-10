import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/data_source.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('heart_rate_parses_every_field', () {
    final sut = HeartRate.fromJson(fixtures.heartRate);
    expect(sut.healthType, HealthType.heartRate);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-heart-rate');
    expect(sut.clientDataId, 'client-1');
    expect(sut.zoneOffsetSeconds, fixtures.offset);
    expect(sut.dataSource,
        const DataSource(appId: 'com.example', deviceId: 'device-1'));
    expect(sut.harmonized.heartRate, 72.0);
    expect(sut.harmonized.min, 60.0);
    expect(sut.harmonized.max, 90.0);
    final series = sut.harmonized.series.single;
    expect(series.heartRate, 70.0);
    expect(series.min, 65.0);
    expect(series.max, 75.0);
    expect(series.startTimestamp, fixtures.start);
    expect(series.endTimestamp, fixtures.start + 60000);
  });

  test('heart_rate_map_carries_the_type_discriminator_and_round_trips', () {
    final sut = HeartRate.fromJson(fixtures.heartRate);
    expect(sut.map['type'], 'heart_rate');
    expect(HeartRate.fromJson(sut.map), sut);
  });

  test('heart_rate_built_in_dart_without_optional_fields', () {
    const sut = HeartRate(
      startTimestamp: fixtures.start,
      endTimestamp: fixtures.end,
      harmonized: HeartRateHarmonized(heartRate: 72),
    );
    expect(sut.map, {
      'type': 'heart_rate',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {
        'heartRate': 72.0,
        'min': null,
        'max': null,
        'series': <dynamic>[],
      },
      'uid': null,
      'clientDataId': null,
      'zoneOffsetSeconds': null,
      'dataSource': null,
    });
    expect(HeartRate.fromJson(sut.map), sut);
  });

  test('heart_rate_minimal_json_parses', () {
    final sut = HeartRate.fromJson({
      'type': 'heart_rate',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {'heartRate': 72},
    });
    expect(sut.harmonized.heartRate, 72.0);
    expect(sut.harmonized.min, isNull);
    expect(sut.harmonized.series, isEmpty);
    expect(sut.uid, isNull);
    expect(sut.dataSource, isNull);
  });

  test('heart_rate_collects_a_list', () {
    final sut = HeartRate.collect([fixtures.heartRate, fixtures.heartRate]);
    expect(sut, hasLength(2));
  });
}
