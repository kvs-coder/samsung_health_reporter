import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BodyTemperature]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A body temperature measurement, in degrees Celsius.
///
/// Supports [map] representation.
///
/// Has a [BodyTemperature.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bodyTemperature] permissions provided.
///
class BodyTemperature extends WritableSample<BodyTemperatureHarmonized> {
  const BodyTemperature({
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
  HealthType get healthType => HealthType.bodyTemperature;

  /// General constructor from JSON payload
  ///
  BodyTemperature.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            BodyTemperatureHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BodyTemperature> collect(List<dynamic> list) =>
      parseObjects(list, BodyTemperature.fromJson);
}

/// Equivalent of [BodyTemperature.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of BodyTemperature.
///
/// Supports [map] representation.
///
/// Has a [BodyTemperatureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BodyTemperatureHarmonized with Payload {
  const BodyTemperatureHarmonized({
    required this.temperature,
  });

  /// Body temperature in degrees Celsius (10–50)
  final double temperature;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'temperature': temperature,
      };

  /// General constructor from JSON payload
  ///
  BodyTemperatureHarmonized.fromJson(Map<String, dynamic> json)
      : temperature = parseDouble(json['temperature']);
}
