import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/irregular_heart_rhythm_notification.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/type/irregular_heart_rhythm_status.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('irregular_heart_rhythm_notification_parses_every_field', () {
    final sut = IrregularHeartRhythmNotification.fromJson(
        fixtures.irregularHeartRhythmNotification);
    expect(sut, isNot(isA<WritableSample>()));
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, isNull);
    expect(sut.uid, 'uid-irregular-heart-rhythm');
    expect(sut.harmonized.status, IrregularHeartRhythmStatus.detected);
  });

  test('irregular_heart_rhythm_notification_round_trips', () {
    final sut = IrregularHeartRhythmNotification.fromJson(
        fixtures.irregularHeartRhythmNotification);
    expect(sut.harmonized.map, {'status': 'DETECTED'});
    expect(IrregularHeartRhythmNotification.fromJson(sut.map), sut);
  });
}
