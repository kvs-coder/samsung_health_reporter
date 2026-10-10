import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [TimeGroupUnit]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The unit aggregate results are grouped by, in local time.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [TimeGroupUnitFactory.from] and [TimeGroupUnitFactory.tryFrom]
/// creating from the [value].
///
enum TimeGroupUnit implements ValueEnum {
  minutely('MINUTELY'),
  hourly('HOURLY'),
  daily('DAILY'),
  weekly('WEEKLY'),
  monthly('MONTHLY'),
  yearly('YEARLY');

  const TimeGroupUnit(this.value);

  /// The Kotlin constant name, e.g. `HOURLY`
  @override
  final String value;
}

extension TimeGroupUnitFactory on TimeGroupUnit {
  /// Finds the case by its [TimeGroupUnit.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static TimeGroupUnit from(String value) =>
      valueOf(TimeGroupUnit.values, value);

  /// The [from] exception handling
  ///
  static TimeGroupUnit? tryFrom(String value) =>
      tryValueOf(TimeGroupUnit.values, value);
}
