import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/body_temperature.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('body_temperature_parses_every_field', () {
    final sut = BodyTemperature.fromJson(fixtures.bodyTemperature);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.bodyTemperature['endTimestamp']);
    expect(sut.uid, 'uid-body-temperature');
    expect(sut.clientDataId, isNull);
    expect(sut.zoneOffsetSeconds, isNull);
    expect(sut.dataSource, isNull);
    expect(sut.harmonized.temperature, 36.6);
  });

  test('body_temperature_round_trips', () {
    final sut = BodyTemperature.fromJson(fixtures.bodyTemperature);
    expect(sut.map['type'], 'body_temperature');
    expect(BodyTemperature.fromJson(sut.map), sut);
  });

  test('body_temperature_reads_integer_numbers_as_doubles', () {
    final sut = BodyTemperature.fromJson({
      ...fixtures.bodyTemperature,
      'harmonized': {'temperature': 10},
    });
    expect(sut.harmonized.temperature, 10.0);
  });
}
