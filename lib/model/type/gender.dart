import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [Gender]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The gender of the user.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [GenderFactory.from] and [GenderFactory.tryFrom]
/// creating from the [value].
///
enum Gender implements ValueEnum {
  unknown('GENDER_UNKNOWN'),
  male('GENDER_MALE'),
  female('GENDER_FEMALE');

  const Gender(this.value);

  /// The Kotlin constant name, e.g. `GENDER_MALE`
  @override
  final String value;
}

extension GenderFactory on Gender {
  /// Finds the case by its [Gender.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static Gender from(String value) => valueOf(Gender.values, value);

  /// The [from] exception handling
  ///
  static Gender? tryFrom(String value) => tryValueOf(Gender.values, value);
}
