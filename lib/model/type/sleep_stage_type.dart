import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [SleepStageType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A sleep stage.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [SleepStageTypeFactory.from] and [SleepStageTypeFactory.tryFrom]
/// creating from the [value].
///
enum SleepStageType implements ValueEnum {
  undefined('UNDEFINED'),
  awake('AWAKE'),
  light('LIGHT'),
  deep('DEEP'),
  rem('REM');

  const SleepStageType(this.value);

  /// The Kotlin constant name, e.g. `AWAKE`
  @override
  final String value;
}

extension SleepStageTypeFactory on SleepStageType {
  /// Finds the case by its [SleepStageType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static SleepStageType from(String value) =>
      valueOf(SleepStageType.values, value);

  /// The [from] exception handling
  ///
  static SleepStageType? tryFrom(String value) =>
      tryValueOf(SleepStageType.values, value);
}
