import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [GlucoseMeasurementType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The type of blood used for a blood glucose measurement.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [GlucoseMeasurementTypeFactory.from] and [GlucoseMeasurementTypeFactory.tryFrom]
/// creating from the [value].
///
enum GlucoseMeasurementType implements ValueEnum {
  undefined('UNDEFINED'),
  wholeBlood('WHOLE_BLOOD'),
  plasma('PLASMA'),
  serum('SERUM');

  const GlucoseMeasurementType(this.value);

  /// The Kotlin constant name, e.g. `WHOLE_BLOOD`
  @override
  final String value;
}

extension GlucoseMeasurementTypeFactory on GlucoseMeasurementType {
  /// Finds the case by its [GlucoseMeasurementType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static GlucoseMeasurementType from(String value) =>
      valueOf(GlucoseMeasurementType.values, value);

  /// The [from] exception handling
  ///
  static GlucoseMeasurementType? tryFrom(String value) =>
      tryValueOf(GlucoseMeasurementType.values, value);
}
