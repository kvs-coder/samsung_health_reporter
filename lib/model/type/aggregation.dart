import '../../exceptions.dart';
import 'health_type.dart';
import 'value_enum.dart';

/// Equivalent of [Aggregation]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One aggregate operation Samsung Health computes over a [healthType].
/// Durations are reported in milliseconds, times of day in seconds
/// since midnight.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [AggregationFactory.from] and
/// [AggregationFactory.tryFrom] creating from the [value].
///
enum Aggregation implements ValueEnum {
  /// total steps
  stepsTotal('STEPS_TOTAL', HealthType.steps, 'count', true),

  /// the last step goal
  stepsGoalLast('STEPS_GOAL_LAST', HealthType.stepsGoal, 'count', false),

  /// total calories burned due to activity
  activitySummaryTotalActiveCaloriesBurned(
      'ACTIVITY_SUMMARY_TOTAL_ACTIVE_CALORIES_BURNED',
      HealthType.activitySummary,
      'kcal',
      true),

  /// total active time
  activitySummaryTotalActiveTime('ACTIVITY_SUMMARY_TOTAL_ACTIVE_TIME',
      HealthType.activitySummary, 'ms', true),

  /// total calories burned
  activitySummaryTotalCaloriesBurned('ACTIVITY_SUMMARY_TOTAL_CALORIES_BURNED',
      HealthType.activitySummary, 'kcal', true),

  /// total distance moved while active
  activitySummaryTotalDistance(
      'ACTIVITY_SUMMARY_TOTAL_DISTANCE', HealthType.activitySummary, 'm', true),

  /// the last active calories burned goal
  activeCaloriesBurnedGoalLast('ACTIVE_CALORIES_BURNED_GOAL_LAST',
      HealthType.activeCaloriesBurnedGoal, 'kcal', false),

  /// the last active time goal
  activeTimeGoalLast(
      'ACTIVE_TIME_GOAL_LAST', HealthType.activeTimeGoal, 'ms', false),

  /// total exercise calories
  exerciseTotalCalories(
      'EXERCISE_TOTAL_CALORIES', HealthType.exercise, 'kcal', true),

  /// total exercise duration
  exerciseTotalDuration(
      'EXERCISE_TOTAL_DURATION', HealthType.exercise, 'ms', false),

  /// total floors climbed
  floorsClimbedTotal(
      'FLOORS_CLIMBED_TOTAL', HealthType.floorsClimbed, 'floor', true),

  /// highest heart rate
  heartRateMax('HEART_RATE_MAX', HealthType.heartRate, 'bpm', false),

  /// lowest heart rate
  heartRateMin('HEART_RATE_MIN', HealthType.heartRate, 'bpm', false),

  /// total food calories
  nutritionTotalCalories(
      'NUTRITION_TOTAL_CALORIES', HealthType.nutrition, 'kcal', true),

  /// the last nutrition goal
  nutritionGoalLastCalories(
      'NUTRITION_GOAL_LAST_CALORIES', HealthType.nutritionGoal, 'kcal', false),

  /// total sleep duration
  sleepTotalDuration('SLEEP_TOTAL_DURATION', HealthType.sleep, 'ms', false),

  /// the last bedtime goal
  sleepGoalLastBedTime(
      'SLEEP_GOAL_LAST_BED_TIME', HealthType.sleepGoal, 's', false),

  /// the last wake-up time goal
  sleepGoalLastWakeUpTime(
      'SLEEP_GOAL_LAST_WAKE_UP_TIME', HealthType.sleepGoal, 's', false),

  /// total water intake
  waterIntakeTotal('WATER_INTAKE_TOTAL', HealthType.waterIntake, 'mL', true),

  /// the last water intake goal
  waterIntakeGoalLast(
      'WATER_INTAKE_GOAL_LAST', HealthType.waterIntakeGoal, 'mL', false);

  const Aggregation(
    this.value,
    this.healthType,
    this.unit,
    this.supportsTimeGrouping,
  );

  /// The Kotlin constant name, e.g. `STEPS_TOTAL`
  @override
  final String value;

  /// The aggregated type
  final HealthType healthType;

  /// Unit of the aggregated value
  final String unit;

  /// Results can be grouped by minute or hour; date-based aggregations
  /// only group by day, week, month or year
  final bool supportsTimeGrouping;
}

extension AggregationFactory on Aggregation {
  /// Finds the aggregation by its [Aggregation.value], e.g. `STEPS_TOTAL`.
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static Aggregation from(String value) => valueOf(Aggregation.values, value);

  /// The [from] exception handling
  ///
  static Aggregation? tryFrom(String value) =>
      tryValueOf(Aggregation.values, value);
}
