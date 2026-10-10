import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/body_composition.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('body_composition_parses_every_field', () {
    final sut = BodyComposition.fromJson(fixtures.bodyComposition);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, isNull);
    expect(sut.uid, 'uid-body-composition');
    final h = sut.harmonized;
    expect(h.weight, 75.5);
    expect(h.height, 180.0);
    expect(h.bodyFat, 18.5);
    expect(h.bodyFatMass, 14.0);
    expect(h.bodyMassIndex, 23.3);
    expect(h.fatFree, 81.5);
    expect(h.fatFreeMass, 61.5);
    expect(h.muscleMass, 45.0);
    expect(h.skeletalMuscle, 40.0);
    expect(h.skeletalMuscleMass, 30.2);
    expect(h.totalBodyWater, 44.1);
    expect(h.basalMetabolicRate, 1700);
  });

  test('body_composition_round_trips', () {
    final sut = BodyComposition.fromJson(fixtures.bodyComposition);
    expect(BodyComposition.fromJson(sut.map), sut);
  });

  test('body_composition_minimal_json_parses', () {
    final sut = BodyComposition.fromJson({
      'type': 'body_composition',
      'startTimestamp': fixtures.start,
      'harmonized': {'weight': 75},
    });
    expect(sut.harmonized.weight, 75.0);
    expect(sut.harmonized.height, isNull);
    expect(sut.harmonized.basalMetabolicRate, isNull);
  });
}
