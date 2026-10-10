import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/payload/skin_temperature.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('skin_temperature_parses_every_field', () {
    final sut = SkinTemperature.fromJson(fixtures.skinTemperature);
    expect(sut, isNot(isA<WritableSample>()));
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-skin-temperature');
    expect(sut.harmonized.skinTemperature, 33.5);
    expect(sut.harmonized.min, 33.0);
    expect(sut.harmonized.max, 34.0);
    final series = sut.harmonized.series.single;
    expect(series.skinTemperature, 33.4);
    expect(series.min, 33.1);
    expect(series.max, 33.8);
    expect(series.startTimestamp, fixtures.start);
    expect(series.endTimestamp, fixtures.start + 60000);
  });

  test('skin_temperature_round_trips', () {
    final sut = SkinTemperature.fromJson(fixtures.skinTemperature);
    expect(SkinTemperature.fromJson(sut.map), sut);
  });

  test('skin_temperature_minimal_json_parses', () {
    final sut = SkinTemperature.fromJson({
      'type': 'skin_temperature',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {'skinTemperature': 33.5},
    });
    expect(sut.harmonized.min, isNull);
    expect(sut.harmonized.series, isEmpty);
  });
}
