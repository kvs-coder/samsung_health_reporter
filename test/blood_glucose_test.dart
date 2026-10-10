import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/blood_glucose.dart';
import 'package:samsung_health_reporter/model/type/glucose_measurement_type.dart';
import 'package:samsung_health_reporter/model/type/glucose_sample_source.dart';
import 'package:samsung_health_reporter/model/type/meal_status.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('blood_glucose_parses_every_field', () {
    final sut = BloodGlucose.fromJson(fixtures.bloodGlucose);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-blood-glucose');
    expect(sut.harmonized.glucoseLevel, 5.5);
    expect(sut.harmonized.mealStatus, MealStatus.afterMeal);
    expect(sut.harmonized.measurementType, GlucoseMeasurementType.wholeBlood);
    expect(sut.harmonized.sampleSource, GlucoseSampleSource.capillary);
    expect(sut.harmonized.insulinInjected, 2.5);
    expect(sut.harmonized.mealTimestamp, fixtures.start - 3600000);
    expect(sut.harmonized.medicationTaken, true);
    final series = sut.harmonized.series.single;
    expect(series.glucose, 5.4);
    expect(series.timestamp, fixtures.start + 300000);
  });

  test('blood_glucose_map_sends_enum_names_and_round_trips', () {
    final sut = BloodGlucose.fromJson(fixtures.bloodGlucose);
    expect(sut.harmonized.map['mealStatus'], 'AFTER_MEAL');
    expect(sut.harmonized.map['measurementType'], 'WHOLE_BLOOD');
    expect(sut.harmonized.map['sampleSource'], 'CAPILLARY');
    expect(BloodGlucose.fromJson(sut.map), sut);
  });

  test('blood_glucose_minimal_json_parses', () {
    final sut = BloodGlucose.fromJson({
      'type': 'blood_glucose',
      'startTimestamp': fixtures.start,
      'harmonized': {
        'glucoseLevel': 5,
        'mealStatus': 'FASTING',
        'measurementType': 'PLASMA',
        'series': <dynamic>[],
      },
    });
    expect(sut.endTimestamp, isNull);
    expect(sut.harmonized.glucoseLevel, 5.0);
    expect(sut.harmonized.sampleSource, isNull);
    expect(sut.harmonized.insulinInjected, isNull);
    expect(sut.harmonized.mealTimestamp, isNull);
    expect(sut.harmonized.medicationTaken, isNull);
    expect(sut.harmonized.series, isEmpty);
    expect(sut.harmonized.map['sampleSource'], isNull);
  });
}
