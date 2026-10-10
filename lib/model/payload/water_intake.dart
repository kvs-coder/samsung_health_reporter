import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [WaterIntake]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Water intake, in milliliters.
///
/// Supports [map] representation.
///
/// Has a [WaterIntake.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.waterIntake] permissions provided.
///
class WaterIntake extends WritableSample<WaterIntakeHarmonized> {
  const WaterIntake({
    required super.startTimestamp,
    this.endTimestamp,
    required super.harmonized,
    super.uid,
    super.clientDataId,
    super.zoneOffsetSeconds,
    super.dataSource,
  });

  /// End time, epoch milliseconds; null for an instantaneous measurement
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.waterIntake;

  /// General constructor from JSON payload
  ///
  WaterIntake.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            WaterIntakeHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WaterIntake> collect(List<dynamic> list) =>
      parseObjects(list, WaterIntake.fromJson);
}

/// Equivalent of [WaterIntake.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of WaterIntake.
///
/// Supports [map] representation.
///
/// Has a [WaterIntakeHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class WaterIntakeHarmonized with Payload {
  const WaterIntakeHarmonized({
    required this.amount,
  });

  /// Amount of water in milliliters
  final double amount;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'amount': amount,
      };

  /// General constructor from JSON payload
  ///
  WaterIntakeHarmonized.fromJson(Map<String, dynamic> json)
      : amount = parseDouble(json['amount']);
}
