import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [Ordering]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Ordering of read results by start time: oldest or newest first.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [OrderingFactory.from] and [OrderingFactory.tryFrom]
/// creating from the [value].
///
enum Ordering implements ValueEnum {
  ascending('ASCENDING'),
  descending('DESCENDING');

  const Ordering(this.value);

  /// The Kotlin constant name, e.g. `DESCENDING`
  @override
  final String value;
}

extension OrderingFactory on Ordering {
  /// Finds the case by its [Ordering.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static Ordering from(String value) => valueOf(Ordering.values, value);

  /// The [from] exception handling
  ///
  static Ordering? tryFrom(String value) => tryValueOf(Ordering.values, value);
}
