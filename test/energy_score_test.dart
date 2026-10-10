import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/energy_score.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('energy_score_parses_every_field', () {
    final sut = EnergyScore.fromJson(fixtures.energyScore);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.energyScore['endTimestamp']);
    expect(sut.uid, 'uid-energy-score');
    expect(sut.clientDataId, isNull);
    expect(sut.zoneOffsetSeconds, isNull);
    expect(sut.dataSource, isNull);
    expect(sut.harmonized.score, 78.0);
  });

  test('energy_score_round_trips', () {
    final sut = EnergyScore.fromJson(fixtures.energyScore);
    expect(sut.map['type'], 'energy_score');
    expect(EnergyScore.fromJson(sut.map), sut);
  });

  test('energy_score_reads_integer_numbers_as_doubles', () {
    final sut = EnergyScore.fromJson({
      ...fixtures.energyScore,
      'harmonized': {'score': 10},
    });
    expect(sut.harmonized.score, 10.0);
  });
}
