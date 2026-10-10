import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [AccessType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// What a permission allows: read (read, aggregate and read changes) or write (insert, update and delete).
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [AccessTypeFactory.from] and [AccessTypeFactory.tryFrom]
/// creating from the [value].
///
enum AccessType implements ValueEnum {
  read('READ'),
  write('WRITE');

  const AccessType(this.value);

  /// The Kotlin constant name, e.g. `WRITE`
  @override
  final String value;
}

extension AccessTypeFactory on AccessType {
  /// Finds the case by its [AccessType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static AccessType from(String value) => valueOf(AccessType.values, value);

  /// The [from] exception handling
  ///
  static AccessType? tryFrom(String value) =>
      tryValueOf(AccessType.values, value);
}
