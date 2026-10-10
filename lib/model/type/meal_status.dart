import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [MealStatus]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The meal status when a blood glucose level was measured.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [MealStatusFactory.from] and [MealStatusFactory.tryFrom]
/// creating from the [value].
///
enum MealStatus implements ValueEnum {
  undefined('UNDEFINED'),
  fasting('FASTING'),
  afterMeal('AFTER_MEAL'),
  beforeBreakfast('BEFORE_BREAKFAST'),
  afterBreakfast('AFTER_BREAKFAST'),
  beforeLunch('BEFORE_LUNCH'),
  afterLunch('AFTER_LUNCH'),
  beforeDinner('BEFORE_DINNER'),
  afterDinner('AFTER_DINNER'),
  afterBedTime('AFTER_BED_TIME'),
  afterSnack('AFTER_SNACK'),
  beforeMeal('BEFORE_MEAL'),
  general('GENERAL'),
  beforeSleep('BEFORE_SLEEP');

  const MealStatus(this.value);

  /// The Kotlin constant name, e.g. `FASTING`
  @override
  final String value;
}

extension MealStatusFactory on MealStatus {
  /// Finds the case by its [MealStatus.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static MealStatus from(String value) => valueOf(MealStatus.values, value);

  /// The [from] exception handling
  ///
  static MealStatus? tryFrom(String value) =>
      tryValueOf(MealStatus.values, value);
}
