import '../../exceptions.dart';

/// An enum of [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
/// whose [value] is the Kotlin constant name, as the library's JSON carries it.
///
abstract interface class ValueEnum {
  /// The Kotlin constant name, e.g. `HEART_RATE`
  String get value;
}

/// Finds the case of [values] whose [ValueEnum.value] is [value].
/// Throws an [InvalidValueException] when no case has it.
///
T valueOf<T extends ValueEnum>(List<T> values, String value) {
  for (final element in values) {
    if (element.value == value) return element;
  }
  throw InvalidValueException('Unknown $T: $value');
}

/// [valueOf] returning null when no case has [value].
///
T? tryValueOf<T extends ValueEnum>(List<T> values, String value) {
  try {
    return valueOf(values, value);
  } on InvalidValueException {
    return null;
  }
}
