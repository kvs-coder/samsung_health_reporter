import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [GlucoseSampleSource]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Where in the body a blood glucose sample was taken.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [GlucoseSampleSourceFactory.from] and [GlucoseSampleSourceFactory.tryFrom]
/// creating from the [value].
///
enum GlucoseSampleSource implements ValueEnum {
  undefined('UNDEFINED'),
  venous('VENOUS'),
  capillary('CAPILLARY');

  const GlucoseSampleSource(this.value);

  /// The Kotlin constant name, e.g. `VENOUS`
  @override
  final String value;
}

extension GlucoseSampleSourceFactory on GlucoseSampleSource {
  /// Finds the case by its [GlucoseSampleSource.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static GlucoseSampleSource from(String value) =>
      valueOf(GlucoseSampleSource.values, value);

  /// The [from] exception handling
  ///
  static GlucoseSampleSource? tryFrom(String value) =>
      tryValueOf(GlucoseSampleSource.values, value);
}
