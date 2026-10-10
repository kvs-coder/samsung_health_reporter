import '../exceptions.dart';
import 'payload/payload.dart';
import 'decorator/extensions.dart';
import 'type/time_group_unit.dart';

/// Equivalent of [TimeGroup]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Groups aggregate results into buckets of [multiplier] × [unit]
/// in local time.
///
/// Throws an [InvalidValueException] when [multiplier] is less than 1.
///
/// Supports [map] representation.
///
/// Has a [TimeGroup.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TimeGroup with Payload {
  TimeGroup({
    required this.unit,
    this.multiplier = 1,
  }) {
    if (multiplier < 1) {
      throw InvalidValueException('Invalid TimeGroup multiplier: $multiplier');
    }
  }

  /// The bucket unit
  final TimeGroupUnit unit;

  /// Units per bucket, at least 1
  final int multiplier;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'unit': unit.value,
        'multiplier': multiplier,
      };

  /// General constructor from JSON payload
  ///
  TimeGroup.fromJson(Map<String, dynamic> json)
      : this(
          unit: TimeGroupUnitFactory.from(json['unit']),
          multiplier:
              json['multiplier'] == null ? 1 : parseInt(json['multiplier']),
        );
}
