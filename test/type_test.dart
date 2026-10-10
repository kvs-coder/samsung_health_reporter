import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/exceptions.dart';
import 'package:samsung_health_reporter/model/type/access_type.dart';
import 'package:samsung_health_reporter/model/type/aggregation.dart';
import 'package:samsung_health_reporter/model/type/exercise_count_type.dart';
import 'package:samsung_health_reporter/model/type/exercise_type.dart';
import 'package:samsung_health_reporter/model/type/gender.dart';
import 'package:samsung_health_reporter/model/type/glucose_measurement_type.dart';
import 'package:samsung_health_reporter/model/type/glucose_sample_source.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/model/type/irregular_heart_rhythm_status.dart';
import 'package:samsung_health_reporter/model/type/meal_status.dart';
import 'package:samsung_health_reporter/model/type/meal_type.dart';
import 'package:samsung_health_reporter/model/type/ordering.dart';
import 'package:samsung_health_reporter/model/type/sleep_apnea_sign.dart';
import 'package:samsung_health_reporter/model/type/sleep_stage_type.dart';
import 'package:samsung_health_reporter/model/type/time_group_unit.dart';
import 'package:samsung_health_reporter/model/type/value_enum.dart';

/// Kotlin constant names of SamsungHealthReporter 1.0.0, in declaration order.
const kotlinNames = <String, List<String>>{
  'AccessType': ['READ', 'WRITE'],
  'TimeGroupUnit': [
    'MINUTELY', 'HOURLY', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY', //
  ],
  'Ordering': ['ASCENDING', 'DESCENDING'],
  'ExerciseCountType': [
    'UNDEFINED', 'STRIDE', 'STROKE', 'SWING', 'REPETITION', //
  ],
  'Gender': ['GENDER_UNKNOWN', 'GENDER_MALE', 'GENDER_FEMALE'],
  'GlucoseMeasurementType': ['UNDEFINED', 'WHOLE_BLOOD', 'PLASMA', 'SERUM'],
  'GlucoseSampleSource': ['UNDEFINED', 'VENOUS', 'CAPILLARY'],
  'IrregularHeartRhythmStatus': ['UNDEFINED', 'DETECTED'],
  'MealStatus': [
    'UNDEFINED', 'FASTING', 'AFTER_MEAL', 'BEFORE_BREAKFAST', //
    'AFTER_BREAKFAST', 'BEFORE_LUNCH', 'AFTER_LUNCH', 'BEFORE_DINNER',
    'AFTER_DINNER', 'AFTER_BED_TIME', 'AFTER_SNACK', 'BEFORE_MEAL',
    'GENERAL', 'BEFORE_SLEEP',
  ],
  'MealType': [
    'UNDEFINED', 'BREAKFAST', 'LUNCH', 'DINNER', 'MORNING_SNACK', //
    'AFTERNOON_SNACK', 'EVENING_SNACK',
  ],
  'SleepApneaSign': ['UNDEFINED', 'DETECTED', 'NOT_DETECTED'],
  'SleepStageType': ['UNDEFINED', 'AWAKE', 'LIGHT', 'DEEP', 'REM'],
  'ExerciseType': [
    'UNDEFINED', 'OTHER', 'WALKING', 'RUNNING', 'STAIR_CLIMBING', //
    'TRACK_RUNNING', 'BASEBALL', 'SOFTBALL', 'CRICKET', 'GOLF', 'BOWLING',
    'HOCKEY', 'RUGBY', 'BASKETBALL', 'SOCCER', 'HANDBALL',
    'AMERICAN_FOOTBALL', 'VOLLEYBALL', 'BEACH_VOLLEYBALL', 'SQUASH',
    'TENNIS', 'BADMINTON', 'TABLE_TENNIS', 'RACQUETBALL', 'BOXING',
    'MARTIAL_ARTS', 'BALLET', 'DANCING', 'BALLROOM_DANCING', 'PILATES',
    'YOGA', 'STRETCHING', 'JUMP_ROPE', 'HULA_HOOPING', 'PUSH_UPS',
    'PULL_UPS', 'SIT_UPS', 'CIRCUIT_TRAINING', 'MOUNTAIN_CLIMBERS',
    'JUMPING_JACKS', 'BURPEES', 'BENCH_PRESS', 'SQUATS', 'LUNGES',
    'LEG_PRESSES', 'LEG_EXTENSIONS', 'LEG_CURLS', 'BACK_EXTENSIONS',
    'LAT_PULLDOWNS', 'DEADLIFTS', 'SHOULDER_PRESSES', 'FRONT_RAISES',
    'LATERAL_RAISES', 'CRUNCH', 'LEG_RAISES', 'PLANK', 'ARM_CURLS',
    'ARM_EXTENSIONS', 'SKATERS', 'HIGH_KNEES', 'INLINE_SKATING',
    'HANG_GLIDING', 'ARCHERY', 'HORSEBACK_RIDING', 'BIKING', 'FLYING_DISC',
    'ROLLER_SKATING', 'AEROBICS', 'HIKING', 'ROCK_CLIMBING', 'BACKPACKING',
    'MOUNTAIN_BIKING', 'ORIENTEERING', 'POOL_SWIMMING', 'AQUA_AEROBICS',
    'CANOEING', 'SAILING', 'SCUBA_DIVING', 'SNORKELING', 'KAYAKING',
    'KITESURFING', 'RAFTING', 'ROWING', 'WINDSURFING', 'YACHTING',
    'WATER_SKIING', 'STEP_MACHINE', 'WEIGHT_MACHINE', 'STATIONARY_BIKING',
    'ROWING_MACHINE', 'TREADMILL', 'ELLIPTICAL', 'STAIR_CLIMBING_MACHINE',
    'CROSS_COUNTRY_SKIING', 'SKIING', 'ICE_DANCING', 'ICE_SKATING',
    'ICE_HOCKEY', 'SNOWBOARDING', 'ALPINE_SKIING', 'SNOWSHOEING',
    'TRIATHLON', 'DUATHLON', 'AQUATHLON', 'AQUABIKE', 'CROSS_TRIATHLON',
    'CROSS_DUATHLON', 'BREAK', 'COOL_DOWN', 'WARM_UP', 'TRANSITION', 'ZUMBA',
    'OPEN_WATER_SWIMMING',
  ],
};

void expectValueEnum<T extends ValueEnum>(
  String name,
  List<T> values,
  T Function(String) from,
  T? Function(String) tryFrom,
) {
  test('${name}_parses_every_kotlin_name_and_throws_for_unknown', () {
    expect(values.map((e) => e.value), kotlinNames[name]);
    for (final sut in values) {
      expect(from(sut.value), sut);
      expect(tryFrom(sut.value), sut);
    }
    expect(() => from('UNKNOWN_VALUE'), throwsA(isA<InvalidValueException>()));
    expect(tryFrom('UNKNOWN_VALUE'), isNull);
  });
}

void main() {
  expectValueEnum('AccessType', AccessType.values, AccessTypeFactory.from,
      AccessTypeFactory.tryFrom);
  expectValueEnum('TimeGroupUnit', TimeGroupUnit.values,
      TimeGroupUnitFactory.from, TimeGroupUnitFactory.tryFrom);
  expectValueEnum('Ordering', Ordering.values, OrderingFactory.from,
      OrderingFactory.tryFrom);
  expectValueEnum('ExerciseType', ExerciseType.values, ExerciseTypeFactory.from,
      ExerciseTypeFactory.tryFrom);
  expectValueEnum('ExerciseCountType', ExerciseCountType.values,
      ExerciseCountTypeFactory.from, ExerciseCountTypeFactory.tryFrom);
  expectValueEnum(
      'Gender', Gender.values, GenderFactory.from, GenderFactory.tryFrom);
  expectValueEnum(
      'GlucoseMeasurementType',
      GlucoseMeasurementType.values,
      GlucoseMeasurementTypeFactory.from,
      GlucoseMeasurementTypeFactory.tryFrom);
  expectValueEnum('GlucoseSampleSource', GlucoseSampleSource.values,
      GlucoseSampleSourceFactory.from, GlucoseSampleSourceFactory.tryFrom);
  expectValueEnum(
      'IrregularHeartRhythmStatus',
      IrregularHeartRhythmStatus.values,
      IrregularHeartRhythmStatusFactory.from,
      IrregularHeartRhythmStatusFactory.tryFrom);
  expectValueEnum('MealStatus', MealStatus.values, MealStatusFactory.from,
      MealStatusFactory.tryFrom);
  expectValueEnum('MealType', MealType.values, MealTypeFactory.from,
      MealTypeFactory.tryFrom);
  expectValueEnum('SleepApneaSign', SleepApneaSign.values,
      SleepApneaSignFactory.from, SleepApneaSignFactory.tryFrom);
  expectValueEnum('SleepStageType', SleepStageType.values,
      SleepStageTypeFactory.from, SleepStageTypeFactory.tryFrom);

  test('exercise_break_is_named_around_the_reserved_word', () {
    expect(ExerciseType.exerciseBreak.value, 'BREAK');
    expect(Gender.male.value, 'GENDER_MALE');
  });

  group('HealthType', () {
    // identifier, Kotlin name, readable, writable, observable
    const kotlin = [
      ['steps', 'STEPS', false, false, false],
      ['steps_goal', 'STEPS_GOAL', false, false, false],
      ['activity_summary', 'ACTIVITY_SUMMARY', false, false, false],
      [
        'active_calories_burned_goal',
        'ACTIVE_CALORIES_BURNED_GOAL',
        false,
        false,
        false
      ],
      ['active_time_goal', 'ACTIVE_TIME_GOAL', false, false, false],
      ['heart_rate', 'HEART_RATE', true, true, true],
      ['blood_oxygen', 'BLOOD_OXYGEN', true, true, true],
      ['blood_pressure', 'BLOOD_PRESSURE', true, true, true],
      ['blood_glucose', 'BLOOD_GLUCOSE', true, true, true],
      ['body_composition', 'BODY_COMPOSITION', true, true, true],
      ['body_temperature', 'BODY_TEMPERATURE', true, true, true],
      ['skin_temperature', 'SKIN_TEMPERATURE', true, false, true],
      ['exercise', 'EXERCISE', true, true, true],
      ['exercise_location', 'EXERCISE_LOCATION', false, false, false],
      ['floors_climbed', 'FLOORS_CLIMBED', true, true, true],
      ['sleep', 'SLEEP', true, true, true],
      ['sleep_goal', 'SLEEP_GOAL', false, false, false],
      ['nutrition', 'NUTRITION', true, true, true],
      ['nutrition_goal', 'NUTRITION_GOAL', false, false, false],
      ['water_intake', 'WATER_INTAKE', true, true, true],
      ['water_intake_goal', 'WATER_INTAKE_GOAL', false, false, false],
      ['energy_score', 'ENERGY_SCORE', true, false, true],
      ['user_profile', 'USER_PROFILE', false, false, false],
      [
        'irregular_heart_rhythm_notification',
        'IRREGULAR_HEART_RHYTHM_NOTIFICATION',
        true,
        false,
        true
      ],
      ['sleep_apnea', 'SLEEP_APNEA', true, false, true],
    ];

    test('health_type_mirrors_every_kotlin_case', () {
      expect(HealthType.values, hasLength(kotlin.length));
      for (var i = 0; i < kotlin.length; i++) {
        final sut = HealthType.values[i];
        expect(
          [
            sut.identifier,
            sut.value,
            sut.isReadable,
            sut.isWritable,
            sut.isObservable
          ],
          kotlin[i],
        );
      }
    });

    test('health_type_parses_identifier_and_value', () {
      for (final sut in HealthType.values) {
        expect(HealthTypeFactory.from(sut.identifier), sut);
        expect(HealthTypeFactory.tryFrom(sut.identifier), sut);
        expect(HealthTypeFactory.fromValue(sut.value), sut);
        expect(HealthTypeFactory.tryFromValue(sut.value), sut);
      }
    });

    test('health_type_throws_for_unknown_identifier_or_value', () {
      expect(() => HealthTypeFactory.from('HEART_RATE'),
          throwsA(isA<InvalidValueException>()));
      expect(() => HealthTypeFactory.fromValue('heart_rate'),
          throwsA(isA<InvalidValueException>()));
      expect(HealthTypeFactory.tryFrom('unknown'), isNull);
      expect(HealthTypeFactory.tryFromValue('UNKNOWN'), isNull);
    });

    test('health_type_lists_its_aggregations', () {
      expect(HealthType.heartRate.aggregations,
          [Aggregation.heartRateMax, Aggregation.heartRateMin]);
      expect(HealthType.sleepGoal.aggregations, [
        Aggregation.sleepGoalLastBedTime,
        Aggregation.sleepGoalLastWakeUpTime
      ]);
      expect(HealthType.bloodPressure.aggregations, isEmpty);
    });
  });

  group('Aggregation', () {
    // Kotlin name, HealthType name, unit, supportsTimeGrouping
    const kotlin = [
      ['STEPS_TOTAL', 'STEPS', 'count', true],
      ['STEPS_GOAL_LAST', 'STEPS_GOAL', 'count', false],
      [
        'ACTIVITY_SUMMARY_TOTAL_ACTIVE_CALORIES_BURNED',
        'ACTIVITY_SUMMARY',
        'kcal',
        true
      ],
      ['ACTIVITY_SUMMARY_TOTAL_ACTIVE_TIME', 'ACTIVITY_SUMMARY', 'ms', true],
      [
        'ACTIVITY_SUMMARY_TOTAL_CALORIES_BURNED',
        'ACTIVITY_SUMMARY',
        'kcal',
        true
      ],
      ['ACTIVITY_SUMMARY_TOTAL_DISTANCE', 'ACTIVITY_SUMMARY', 'm', true],
      [
        'ACTIVE_CALORIES_BURNED_GOAL_LAST',
        'ACTIVE_CALORIES_BURNED_GOAL',
        'kcal',
        false
      ],
      ['ACTIVE_TIME_GOAL_LAST', 'ACTIVE_TIME_GOAL', 'ms', false],
      ['EXERCISE_TOTAL_CALORIES', 'EXERCISE', 'kcal', true],
      ['EXERCISE_TOTAL_DURATION', 'EXERCISE', 'ms', false],
      ['FLOORS_CLIMBED_TOTAL', 'FLOORS_CLIMBED', 'floor', true],
      ['HEART_RATE_MAX', 'HEART_RATE', 'bpm', false],
      ['HEART_RATE_MIN', 'HEART_RATE', 'bpm', false],
      ['NUTRITION_TOTAL_CALORIES', 'NUTRITION', 'kcal', true],
      ['NUTRITION_GOAL_LAST_CALORIES', 'NUTRITION_GOAL', 'kcal', false],
      ['SLEEP_TOTAL_DURATION', 'SLEEP', 'ms', false],
      ['SLEEP_GOAL_LAST_BED_TIME', 'SLEEP_GOAL', 's', false],
      ['SLEEP_GOAL_LAST_WAKE_UP_TIME', 'SLEEP_GOAL', 's', false],
      ['WATER_INTAKE_TOTAL', 'WATER_INTAKE', 'mL', true],
      ['WATER_INTAKE_GOAL_LAST', 'WATER_INTAKE_GOAL', 'mL', false],
    ];

    test('aggregation_mirrors_every_kotlin_case', () {
      expect(Aggregation.values, hasLength(kotlin.length));
      for (var i = 0; i < kotlin.length; i++) {
        final sut = Aggregation.values[i];
        expect(
          [sut.value, sut.healthType.value, sut.unit, sut.supportsTimeGrouping],
          kotlin[i],
        );
      }
    });

    test('aggregation_parses_every_name_and_throws_for_unknown', () {
      for (final sut in Aggregation.values) {
        expect(AggregationFactory.from(sut.value), sut);
        expect(AggregationFactory.tryFrom(sut.value), sut);
      }
      expect(() => AggregationFactory.from('STEPS_MAX'),
          throwsA(isA<InvalidValueException>()));
      expect(AggregationFactory.tryFrom('STEPS_MAX'), isNull);
    });
  });
}
