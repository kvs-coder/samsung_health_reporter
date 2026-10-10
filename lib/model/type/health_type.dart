import '../../exceptions.dart';
import 'aggregation.dart';
import 'value_enum.dart';

/// Equivalent of [HealthType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One Samsung Health data type.
///
/// [identifier] is the stable library identifier (`heart_rate`), carried
/// by a sample's `type` discriminator; [value] is the Kotlin constant name
/// (`HEART_RATE`), carried by permissions, change sets and aggregations.
///
/// Has factory methods [HealthTypeFactory.from] and [HealthTypeFactory.tryFrom]
/// creating from the [identifier], and [HealthTypeFactory.fromValue] and
/// [HealthTypeFactory.tryFromValue] creating from the [value].
///
enum HealthType implements ValueEnum {
  /// steps, aggregate only: [Aggregation.stepsTotal]
  steps('steps', 'STEPS', false, false, false),

  /// the step goal, aggregate only: [Aggregation.stepsGoalLast]
  stepsGoal('steps_goal', 'STEPS_GOAL', false, false, false),

  /// the daily activity summary, aggregate only
  activitySummary('activity_summary', 'ACTIVITY_SUMMARY', false, false, false),

  /// the active calories burned goal, aggregate only
  activeCaloriesBurnedGoal('active_calories_burned_goal',
      'ACTIVE_CALORIES_BURNED_GOAL', false, false, false),

  /// the active time goal, aggregate only
  activeTimeGoal('active_time_goal', 'ACTIVE_TIME_GOAL', false, false, false),

  /// heart rate, [HeartRate]
  heartRate('heart_rate', 'HEART_RATE', true, true, true),

  /// blood oxygen saturation, [BloodOxygen]
  bloodOxygen('blood_oxygen', 'BLOOD_OXYGEN', true, true, true),

  /// blood pressure, [BloodPressure]
  bloodPressure('blood_pressure', 'BLOOD_PRESSURE', true, true, true),

  /// blood glucose, [BloodGlucose]
  bloodGlucose('blood_glucose', 'BLOOD_GLUCOSE', true, true, true),

  /// weight and body composition, [BodyComposition]
  bodyComposition('body_composition', 'BODY_COMPOSITION', true, true, true),

  /// body temperature, [BodyTemperature]
  bodyTemperature('body_temperature', 'BODY_TEMPERATURE', true, true, true),

  /// skin temperature, [SkinTemperature]
  skinTemperature('skin_temperature', 'SKIN_TEMPERATURE', true, false, true),

  /// exercise, [Exercise]
  exercise('exercise', 'EXERCISE', true, true, true),

  /// permission-only type that grants access to [ExerciseSession.route]
  exerciseLocation(
      'exercise_location', 'EXERCISE_LOCATION', false, false, false),

  /// floors climbed, [FloorsClimbed]
  floorsClimbed('floors_climbed', 'FLOORS_CLIMBED', true, true, true),

  /// sleep, [Sleep]
  sleep('sleep', 'SLEEP', true, true, true),

  /// the sleep goal, aggregate only
  sleepGoal('sleep_goal', 'SLEEP_GOAL', false, false, false),

  /// nutrition, [Nutrition]
  nutrition('nutrition', 'NUTRITION', true, true, true),

  /// the nutrition goal, aggregate only
  nutritionGoal('nutrition_goal', 'NUTRITION_GOAL', false, false, false),

  /// water intake, [WaterIntake]
  waterIntake('water_intake', 'WATER_INTAKE', true, true, true),

  /// the water intake goal, aggregate only
  waterIntakeGoal(
      'water_intake_goal', 'WATER_INTAKE_GOAL', false, false, false),

  /// the daily energy score, [EnergyScore]
  energyScore('energy_score', 'ENERGY_SCORE', true, false, true),

  /// the user profile, [UserProfile]
  userProfile('user_profile', 'USER_PROFILE', false, false, false),

  /// irregular heart rhythm notifications, [IrregularHeartRhythmNotification]
  irregularHeartRhythmNotification('irregular_heart_rhythm_notification',
      'IRREGULAR_HEART_RHYTHM_NOTIFICATION', true, false, true),

  /// sleep apnea signs, [SleepApnea]
  sleepApnea('sleep_apnea', 'SLEEP_APNEA', true, false, true);

  const HealthType(
    this.identifier,
    this.value,
    this.isReadable,
    this.isWritable,
    this.isObservable,
  );

  /// Stable library identifier, e.g. `heart_rate`
  final String identifier;

  /// The Kotlin constant name, e.g. `HEART_RATE`
  @override
  final String value;

  /// Data points can be read
  final bool isReadable;

  /// Data points can be inserted, updated and deleted
  final bool isWritable;

  /// Changes can be read
  final bool isObservable;

  /// The aggregations available for this type
  List<Aggregation> get aggregations =>
      Aggregation.values.where((e) => e.healthType == this).toList();
}

extension HealthTypeFactory on HealthType {
  /// Finds the type by its [HealthType.identifier], e.g. `heart_rate`.
  /// Throws an [InvalidValueException] for an unknown identifier.
  ///
  static HealthType from(String identifier) {
    for (final type in HealthType.values) {
      if (type.identifier == identifier) return type;
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static HealthType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }

  /// Finds the type by its [HealthType.value], e.g. `HEART_RATE`.
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static HealthType fromValue(String value) =>
      valueOf(HealthType.values, value);

  /// The [fromValue] exception handling
  ///
  static HealthType? tryFromValue(String value) =>
      tryValueOf(HealthType.values, value);
}
