import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [SkinTemperature]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Skin temperature over an interval, in degrees Celsius. Read-only.
///
/// Supports [map] representation.
///
/// Has a [SkinTemperature.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.skinTemperature] permissions provided.
///
class SkinTemperature extends Sample<SkinTemperatureHarmonized> {
  const SkinTemperature({
    required super.startTimestamp,
    required this.endTimestamp,
    required super.harmonized,
    super.uid,
    super.clientDataId,
    super.zoneOffsetSeconds,
    super.dataSource,
  });

  /// End time, epoch milliseconds, not before [startTimestamp]
  @override
  final int endTimestamp;

  @override
  HealthType get healthType => HealthType.skinTemperature;

  /// General constructor from JSON payload
  ///
  SkinTemperature.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            SkinTemperatureHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<SkinTemperature> collect(List<dynamic> list) =>
      parseObjects(list, SkinTemperature.fromJson);
}

/// Equivalent of [SkinTemperature.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Skin temperature values, in degrees Celsius (10–50).
///
/// Supports [map] representation.
///
/// Has a [SkinTemperatureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SkinTemperatureHarmonized with Payload {
  const SkinTemperatureHarmonized({
    required this.skinTemperature,
    this.min,
    this.max,
    this.series = const [],
  });

  /// The skin temperature, °C
  final double skinTemperature;

  /// The lowest skin temperature in the interval, °C
  final double? min;

  /// The highest skin temperature in the interval, °C
  final double? max;

  /// Continuous measurements within the interval
  final List<SkinTemperatureSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'skinTemperature': skinTemperature,
        'min': min,
        'max': max,
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  SkinTemperatureHarmonized.fromJson(Map<String, dynamic> json)
      : skinTemperature = parseDouble(json['skinTemperature']),
        min = tryParseDouble(json['min']),
        max = tryParseDouble(json['max']),
        series = parseObjects(json['series'], SkinTemperatureSeries.fromJson);
}

/// Equivalent of [SkinTemperature.Series]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One continuous skin temperature measurement, in degrees Celsius.
///
/// Supports [map] representation.
///
/// Has a [SkinTemperatureSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SkinTemperatureSeries with Payload {
  const SkinTemperatureSeries({
    required this.skinTemperature,
    required this.min,
    required this.max,
    required this.startTimestamp,
    required this.endTimestamp,
  });

  /// The skin temperature, °C
  final double skinTemperature;

  /// The lowest value
  final double min;

  /// The highest value
  final double max;

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds
  final int endTimestamp;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'skinTemperature': skinTemperature,
        'min': min,
        'max': max,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
      };

  /// General constructor from JSON payload
  ///
  SkinTemperatureSeries.fromJson(Map<String, dynamic> json)
      : skinTemperature = parseDouble(json['skinTemperature']),
        min = parseDouble(json['min']),
        max = parseDouble(json['max']),
        startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']);
}
