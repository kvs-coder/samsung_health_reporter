import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/exercise.dart';
import 'package:samsung_health_reporter/model/type/exercise_count_type.dart';
import 'package:samsung_health_reporter/model/type/exercise_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('exercise_parses_every_field', () {
    final sut = Exercise.fromJson(fixtures.exercise);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.uid, 'uid-exercise');
    expect(sut.zoneOffsetSeconds, fixtures.offset);
    expect(sut.dataSource?.appId, 'com.example');
    expect(sut.harmonized.exerciseType, ExerciseType.running);
    expect(sut.harmonized.customTitle, 'Morning run');
    final s = sut.harmonized.sessions.single;
    expect(s.exerciseType, ExerciseType.running);
    expect(s.startTimestamp, fixtures.start);
    expect(s.endTimestamp, fixtures.end);
    expect(s.durationMillis, 3600000);
    expect(s.calories, 500.0);
    expect(s.customTitle, 'Morning run');
    expect(s.comment, 'Felt good');
    expect(s.distance, 10000.0);
    expect(s.count, 9000);
    expect(s.countType, ExerciseCountType.stride);
    expect(s.altitudeGain, 50.0);
    expect(s.altitudeLoss, 45.0);
    expect(s.maxAltitude, 120.0);
    expect(s.minAltitude, 70.0);
    expect(s.inclineDistance, 2000.0);
    expect(s.declineDistance, 1800.0);
    expect(s.maxCadence, 180.0);
    expect(s.meanCadence, 165.0);
    expect(s.maxCalorieBurnRate, 800.0);
    expect(s.meanCalorieBurnRate, 500.0);
    expect(s.maxHeartRate, 175.0);
    expect(s.meanHeartRate, 150.0);
    expect(s.minHeartRate, 90.0);
    expect(s.maxPower, 300.0);
    expect(s.meanPower, 200.0);
    expect(s.maxRpm, 90.0);
    expect(s.meanRpm, 80.0);
    expect(s.maxSpeed, 4.5);
    expect(s.meanSpeed, 2.8);
    expect(s.vo2Max, 48.5);
    final log = s.log.single;
    expect(log.timestamp, fixtures.start + 60000);
    expect(log.heartRate, 140.0);
    expect(log.cadence, 160.0);
    expect(log.count, 150);
    expect(log.power, 190.0);
    expect(log.speed, 2.7);
    final location = s.route.single;
    expect(location.timestamp, fixtures.start + 60000);
    expect(location.latitude, 52.52);
    expect(location.longitude, 13.405);
    expect(location.altitude, 34.0);
    expect(location.accuracy, 5.0);
  });

  test('exercise_round_trips', () {
    final sut = Exercise.fromJson(fixtures.exercise);
    final session = sut.harmonized.sessions.single.map;
    expect(session['exerciseType'], 'RUNNING');
    expect(session['countType'], 'STRIDE');
    expect(Exercise.fromJson(sut.map), sut);
  });

  test('exercise_session_without_optional_fields_parses', () {
    final sut = ExerciseSession.fromJson({
      'exerciseType': 'WALKING',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'durationMillis': 3600000,
      'calories': 100,
      'log': <dynamic>[],
      'route': <dynamic>[],
    });
    expect(sut.calories, 100.0);
    expect(sut.countType, isNull);
    expect(sut.count, isNull);
    expect(sut.vo2Max, isNull);
    expect(sut.log, isEmpty);
    expect(sut.route, isEmpty);
    expect(sut.map['countType'], isNull);
    expect(ExerciseSession.fromJson(sut.map), sut);
  });

  test('exercise_built_in_dart_sends_lists_never_null', () {
    const sut = Exercise(
      startTimestamp: fixtures.start,
      endTimestamp: fixtures.end,
      harmonized: ExerciseHarmonized(
        exerciseType: ExerciseType.exerciseBreak,
        sessions: [
          ExerciseSession(
            exerciseType: ExerciseType.exerciseBreak,
            startTimestamp: fixtures.start,
            endTimestamp: fixtures.end,
            durationMillis: 3600000,
            calories: 0,
          ),
        ],
      ),
    );
    final session = sut.harmonized.sessions.single.map;
    expect(sut.harmonized.map['exerciseType'], 'BREAK');
    expect(session['log'], isEmpty);
    expect(session['route'], isEmpty);
    expect(Exercise.fromJson(sut.map), sut);
  });
}
