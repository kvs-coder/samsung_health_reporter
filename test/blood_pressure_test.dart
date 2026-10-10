import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/blood_pressure.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('blood_pressure_parses_every_field', () {
    final sut = BloodPressure.fromJson(fixtures.bloodPressure);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, isNull);
    expect(sut.uid, 'uid-blood-pressure');
    expect(sut.harmonized.systolic, 120.0);
    expect(sut.harmonized.diastolic, 80.0);
    expect(sut.harmonized.mean, 93.3);
    expect(sut.harmonized.pulseRate, 70);
    expect(sut.harmonized.medicationTaken, false);
  });

  test('blood_pressure_round_trips', () {
    final sut = BloodPressure.fromJson(fixtures.bloodPressure);
    expect(BloodPressure.fromJson(sut.map), sut);
  });

  test('blood_pressure_minimal_json_parses', () {
    final sut = BloodPressure.fromJson({
      'type': 'blood_pressure',
      'startTimestamp': fixtures.start,
      'harmonized': {'systolic': 120, 'diastolic': 80, 'mean': 93},
    });
    expect(sut.harmonized.mean, 93.0);
    expect(sut.harmonized.pulseRate, isNull);
    expect(sut.harmonized.medicationTaken, isNull);
  });
}
