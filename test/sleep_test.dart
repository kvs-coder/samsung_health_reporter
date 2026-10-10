import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/sleep.dart';
import 'package:samsung_health_reporter/model/type/sleep_stage_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('sleep_parses_every_field', () {
    final sut = Sleep.fromJson(fixtures.sleep);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-sleep');
    expect(sut.harmonized.durationMillis, 3600000);
    expect(sut.harmonized.sleepScore, 85);
    final session = sut.harmonized.sessions.single;
    expect(session.startTimestamp, fixtures.start);
    expect(session.endTimestamp, fixtures.end);
    expect(session.durationMillis, 3600000);
    expect(session.stages, hasLength(2));
    expect(session.stages.first.startTimestamp, fixtures.start);
    expect(session.stages.first.endTimestamp, fixtures.start + 1800000);
    expect(session.stages.first.stage, SleepStageType.light);
    expect(session.stages.last.stage, SleepStageType.deep);
  });

  test('sleep_round_trips', () {
    final sut = Sleep.fromJson(fixtures.sleep);
    expect(sut.harmonized.sessions.single.stages.last.map['stage'], 'DEEP');
    expect(Sleep.fromJson(sut.map), sut);
  });

  test('sleep_without_score_or_stages_parses', () {
    final sut = Sleep.fromJson({
      'type': 'sleep',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {
        'durationMillis': 3600000,
        'sessions': [
          {
            'startTimestamp': fixtures.start,
            'endTimestamp': fixtures.end,
            'durationMillis': 3600000,
          },
        ],
      },
    });
    expect(sut.harmonized.sleepScore, isNull);
    expect(sut.harmonized.sessions.single.stages, isEmpty);
  });
}
