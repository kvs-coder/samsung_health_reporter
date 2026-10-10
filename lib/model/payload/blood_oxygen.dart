import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BloodOxygen]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Blood oxygen saturation over an interval, in percent.
///
/// Supports [map] representation.
///
/// Has a [BloodOxygen.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bloodOxygen] permissions provided.
///
class BloodOxygen extends WritableSample<BloodOxygenHarmonized> {
  const BloodOxygen({
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
  HealthType get healthType => HealthType.bloodOxygen;

  /// General constructor from JSON payload
  ///
  BloodOxygen.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            BloodOxygenHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BloodOxygen> collect(List<dynamic> list) =>
      parseObjects(list, BloodOxygen.fromJson);
}

/// Equivalent of [BloodOxygen.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Blood oxygen saturation values, in percent (0–100).
///
/// Supports [map] representation.
///
/// Has a [BloodOxygenHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodOxygenHarmonized with Payload {
  const BloodOxygenHarmonized({
    required this.oxygenSaturation,
    this.min,
    this.max,
    this.series = const [],
  });

  /// The oxygen saturation, percent
  final double oxygenSaturation;

  /// The lowest oxygen saturation in the interval, percent
  final double? min;

  /// The highest oxygen saturation in the interval, percent
  final double? max;

  /// Continuous measurements within the interval
  final List<BloodOxygenSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'oxygenSaturation': oxygenSaturation,
        'min': min,
        'max': max,
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  BloodOxygenHarmonized.fromJson(Map<String, dynamic> json)
      : oxygenSaturation = parseDouble(json['oxygenSaturation']),
        min = tryParseDouble(json['min']),
        max = tryParseDouble(json['max']),
        series = parseObjects(json['series'], BloodOxygenSeries.fromJson);
}

/// Equivalent of [BloodOxygen.Series]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One continuous blood oxygen measurement, in percent.
///
/// Supports [map] representation.
///
/// Has a [BloodOxygenSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodOxygenSeries with Payload {
  const BloodOxygenSeries({
    required this.oxygenSaturation,
    required this.min,
    required this.max,
    required this.startTimestamp,
    required this.endTimestamp,
  });

  /// The oxygen saturation, percent
  final double oxygenSaturation;

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
        'oxygenSaturation': oxygenSaturation,
        'min': min,
        'max': max,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
      };

  /// General constructor from JSON payload
  ///
  BloodOxygenSeries.fromJson(Map<String, dynamic> json)
      : oxygenSaturation = parseDouble(json['oxygenSaturation']),
        min = parseDouble(json['min']),
        max = parseDouble(json['max']),
        startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']);
}
