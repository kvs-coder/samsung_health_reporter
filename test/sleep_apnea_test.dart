import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/payload/sleep_apnea.dart';
import 'package:samsung_health_reporter/model/type/sleep_apnea_sign.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('sleep_apnea_parses_every_field', () {
    final sut = SleepApnea.fromJson(fixtures.sleepApnea);
    expect(sut, isNot(isA<WritableSample>()));
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-sleep-apnea');
    expect(sut.harmonized.detectedSign, SleepApneaSign.notDetected);
  });

  test('sleep_apnea_round_trips', () {
    final sut = SleepApnea.fromJson(fixtures.sleepApnea);
    expect(sut.harmonized.map, {'detectedSign': 'NOT_DETECTED'});
    expect(SleepApnea.fromJson(sut.map), sut);
  });
}
