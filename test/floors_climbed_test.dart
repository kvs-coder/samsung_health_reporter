import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/floors_climbed.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('floors_climbed_parses_every_field', () {
    final sut = FloorsClimbed.fromJson(fixtures.floorsClimbed);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.floorsClimbed['endTimestamp']);
    expect(sut.uid, 'uid-floors-climbed');
    expect(sut.clientDataId, isNull);
    expect(sut.zoneOffsetSeconds, isNull);
    expect(sut.dataSource, isNull);
    expect(sut.harmonized.floor, 12.0);
  });

  test('floors_climbed_round_trips', () {
    final sut = FloorsClimbed.fromJson(fixtures.floorsClimbed);
    expect(sut.map['type'], 'floors_climbed');
    expect(FloorsClimbed.fromJson(sut.map), sut);
  });

  test('floors_climbed_reads_integer_numbers_as_doubles', () {
    final sut = FloorsClimbed.fromJson({
      ...fixtures.floorsClimbed,
      'harmonized': {'floor': 10},
    });
    expect(sut.harmonized.floor, 10.0);
  });
}
