import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [IrregularHeartRhythmStatus]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The status of irregular heart rhythm detection.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [IrregularHeartRhythmStatusFactory.from] and [IrregularHeartRhythmStatusFactory.tryFrom]
/// creating from the [value].
///
enum IrregularHeartRhythmStatus implements ValueEnum {
  undefined('UNDEFINED'),
  detected('DETECTED');

  const IrregularHeartRhythmStatus(this.value);

  /// The Kotlin constant name, e.g. `DETECTED`
  @override
  final String value;
}

extension IrregularHeartRhythmStatusFactory on IrregularHeartRhythmStatus {
  /// Finds the case by its [IrregularHeartRhythmStatus.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static IrregularHeartRhythmStatus from(String value) =>
      valueOf(IrregularHeartRhythmStatus.values, value);

  /// The [from] exception handling
  ///
  static IrregularHeartRhythmStatus? tryFrom(String value) =>
      tryValueOf(IrregularHeartRhythmStatus.values, value);
}
