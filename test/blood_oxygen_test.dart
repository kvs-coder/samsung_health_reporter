import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/blood_oxygen.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('blood_oxygen_parses_every_field', () {
    final sut = BloodOxygen.fromJson(fixtures.bloodOxygen);
    expect(sut, isA<WritableSample>());
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-blood-oxygen');
    expect(sut.zoneOffsetSeconds, fixtures.offset);
    expect(sut.dataSource?.appId, 'com.example');
    expect(sut.dataSource?.deviceId, 'device-1');
    expect(sut.harmonized.oxygenSaturation, 97.0);
    expect(sut.harmonized.min, 95.0);
    expect(sut.harmonized.max, 99.0);
    final series = sut.harmonized.series.single;
    expect(series.oxygenSaturation, 96.0);
    expect(series.min, 95.0);
    expect(series.max, 98.0);
    expect(series.startTimestamp, fixtures.start);
    expect(series.endTimestamp, fixtures.start + 60000);
  });

  test('blood_oxygen_round_trips', () {
    final sut = BloodOxygen.fromJson(fixtures.bloodOxygen);
    expect(BloodOxygen.fromJson(sut.map), sut);
  });

  test('blood_oxygen_minimal_json_parses', () {
    final sut = BloodOxygen.fromJson({
      'type': 'blood_oxygen',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {'oxygenSaturation': 97},
    });
    expect(sut.harmonized.oxygenSaturation, 97.0);
    expect(sut.harmonized.max, isNull);
    expect(sut.harmonized.series, isEmpty);
  });
}
