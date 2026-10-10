import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/water_intake.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('water_intake_parses_every_field', () {
    final sut = WaterIntake.fromJson(fixtures.waterIntake);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.waterIntake['endTimestamp']);
    expect(sut.uid, 'uid-water-intake');
    expect(sut.clientDataId, isNull);
    expect(sut.zoneOffsetSeconds, isNull);
    expect(sut.dataSource, isNull);
    expect(sut.harmonized.amount, 250.0);
  });

  test('water_intake_round_trips', () {
    final sut = WaterIntake.fromJson(fixtures.waterIntake);
    expect(sut.map['type'], 'water_intake');
    expect(WaterIntake.fromJson(sut.map), sut);
  });

  test('water_intake_reads_integer_numbers_as_doubles', () {
    final sut = WaterIntake.fromJson({
      ...fixtures.waterIntake,
      'harmonized': {'amount': 10},
    });
    expect(sut.harmonized.amount, 10.0);
  });
}
