import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ExerciseCountType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// What the count of a countable exercise measures.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ExerciseCountTypeFactory.from] and [ExerciseCountTypeFactory.tryFrom]
/// creating from the [value].
///
enum ExerciseCountType implements ValueEnum {
  undefined('UNDEFINED'),
  stride('STRIDE'),
  stroke('STROKE'),
  swing('SWING'),
  repetition('REPETITION');

  const ExerciseCountType(this.value);

  /// The Kotlin constant name, e.g. `STRIDE`
  @override
  final String value;
}

extension ExerciseCountTypeFactory on ExerciseCountType {
  /// Finds the case by its [ExerciseCountType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static ExerciseCountType from(String value) =>
      valueOf(ExerciseCountType.values, value);

  /// The [from] exception handling
  ///
  static ExerciseCountType? tryFrom(String value) =>
      tryValueOf(ExerciseCountType.values, value);
}
