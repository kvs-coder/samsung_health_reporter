import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/exceptions.dart';
import 'package:samsung_health_reporter/model/payload/blood_glucose.dart';
import 'package:samsung_health_reporter/model/payload/blood_oxygen.dart';
import 'package:samsung_health_reporter/model/payload/blood_pressure.dart';
import 'package:samsung_health_reporter/model/payload/body_composition.dart';
import 'package:samsung_health_reporter/model/payload/body_temperature.dart';
import 'package:samsung_health_reporter/model/payload/energy_score.dart';
import 'package:samsung_health_reporter/model/payload/exercise.dart';
import 'package:samsung_health_reporter/model/payload/floors_climbed.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/payload/irregular_heart_rhythm_notification.dart';
import 'package:samsung_health_reporter/model/payload/nutrition.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/payload/skin_temperature.dart';
import 'package:samsung_health_reporter/model/payload/sleep.dart';
import 'package:samsung_health_reporter/model/payload/sleep_apnea.dart';
import 'package:samsung_health_reporter/model/payload/water_intake.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  const expectedTypes = {
    'heart_rate': HeartRate,
    'blood_oxygen': BloodOxygen,
    'blood_pressure': BloodPressure,
    'blood_glucose': BloodGlucose,
    'body_composition': BodyComposition,
    'body_temperature': BodyTemperature,
    'skin_temperature': SkinTemperature,
    'exercise': Exercise,
    'floors_climbed': FloorsClimbed,
    'sleep': Sleep,
    'nutrition': Nutrition,
    'water_intake': WaterIntake,
    'energy_score': EnergyScore,
    'irregular_heart_rhythm_notification': IrregularHeartRhythmNotification,
    'sleep_apnea': SleepApnea,
  };

  test('every_readable_type_has_a_sample_fixture', () {
    final readable = HealthType.values
        .where((e) => e.isReadable)
        .map((e) => e.identifier)
        .toSet();
    expect(fixtures.samples.keys.toSet(), readable);
    expect(expectedTypes.keys.toSet(), readable);
  });

  for (final entry in fixtures.samples.entries) {
    test('factory_creates_${entry.key}_and_round_trips', () {
      final sut = Sample.factory(entry.value);
      expect(sut.runtimeType, expectedTypes[entry.key]);
      expect(sut.healthType.identifier, entry.key);
      expect(sut.map['type'], entry.key);
      expect(sut is WritableSample, sut.healthType.isWritable);
      expect(Sample.factory(sut.map), sut);
      expect(Sample.factory(jsonDecode(jsonEncode(sut.map))), sut);
    });
  }

  test('factory_throws_for_an_unknown_type', () {
    expect(
      () => Sample.factory({...fixtures.heartRate, 'type': 'steps_per_hour'}),
      throwsA(isA<InvalidValueException>()),
    );
  });

  test('factory_throws_for_a_type_without_samples', () {
    for (final type in HealthType.values.where((e) => !e.isReadable)) {
      expect(
        () => Sample.factory({...fixtures.heartRate, 'type': type.identifier}),
        throwsA(isA<InvalidValueException>()),
        reason: type.identifier,
      );
    }
  });

  test('factory_throws_without_a_type', () {
    final json = Map<String, dynamic>.from(fixtures.heartRate)..remove('type');
    expect(() => Sample.factory(json), throwsA(isA<InvalidValueException>()));
  });

  test('factory_does_not_accept_the_enum_name_as_type', () {
    expect(
      () => Sample.factory({...fixtures.heartRate, 'type': 'HEART_RATE'}),
      throwsA(isA<InvalidValueException>()),
    );
  });

  test('collect_reads_maps_and_json_strings', () {
    final sut = Sample.collect([
      fixtures.heartRate,
      jsonEncode(fixtures.sleep),
      Map<Object?, Object?>.from(fixtures.waterIntake),
    ]);
    expect(sut.map((e) => e.runtimeType), [HeartRate, Sleep, WaterIntake]);
  });

  test('samples_with_different_uids_are_not_equal', () {
    final sut = HeartRate.fromJson(fixtures.heartRate);
    final other = HeartRate.fromJson({...fixtures.heartRate, 'uid': 'other'});
    expect(sut, isNot(other));
    expect(sut.hashCode, HeartRate.fromJson(fixtures.heartRate).hashCode);
  });
}
