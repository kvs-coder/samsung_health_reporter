import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [SleepApneaSign]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The detected sign of sleep apnea.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [SleepApneaSignFactory.from] and [SleepApneaSignFactory.tryFrom]
/// creating from the [value].
///
enum SleepApneaSign implements ValueEnum {
  undefined('UNDEFINED'),
  detected('DETECTED'),
  notDetected('NOT_DETECTED');

  const SleepApneaSign(this.value);

  /// The Kotlin constant name, e.g. `DETECTED`
  @override
  final String value;
}

extension SleepApneaSignFactory on SleepApneaSign {
  /// Finds the case by its [SleepApneaSign.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static SleepApneaSign from(String value) =>
      valueOf(SleepApneaSign.values, value);

  /// The [from] exception handling
  ///
  static SleepApneaSign? tryFrom(String value) =>
      tryValueOf(SleepApneaSign.values, value);
}
