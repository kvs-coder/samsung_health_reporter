import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [MealType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The meal a nutrition record belongs to.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [MealTypeFactory.from] and [MealTypeFactory.tryFrom]
/// creating from the [value].
///
enum MealType implements ValueEnum {
  undefined('UNDEFINED'),
  breakfast('BREAKFAST'),
  lunch('LUNCH'),
  dinner('DINNER'),
  morningSnack('MORNING_SNACK'),
  afternoonSnack('AFTERNOON_SNACK'),
  eveningSnack('EVENING_SNACK');

  const MealType(this.value);

  /// The Kotlin constant name, e.g. `BREAKFAST`
  @override
  final String value;
}

extension MealTypeFactory on MealType {
  /// Finds the case by its [MealType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static MealType from(String value) => valueOf(MealType.values, value);

  /// The [from] exception handling
  ///
  static MealType? tryFrom(String value) => tryValueOf(MealType.values, value);
}
