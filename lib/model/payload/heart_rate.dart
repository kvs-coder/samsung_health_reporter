import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [HeartRate]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Heart rate over an interval, in beats per minute.
///
/// Supports [map] representation.
///
/// Has a [HeartRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.heartRate] permissions provided.
///
class HeartRate extends WritableSample<HeartRateHarmonized> {
  const HeartRate({
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
  HealthType get healthType => HealthType.heartRate;

  /// General constructor from JSON payload
  ///
  HeartRate.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            HeartRateHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<HeartRate> collect(List<dynamic> list) =>
      parseObjects(list, HeartRate.fromJson);
}

/// Equivalent of [HeartRate.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Heart rate values, in beats per minute (0–300).
///
/// Supports [map] representation.
///
/// Has a [HeartRateHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeartRateHarmonized with Payload {
  const HeartRateHarmonized({
    required this.heartRate,
    this.min,
    this.max,
    this.series = const [],
  });

  /// The heart rate, bpm
  final double heartRate;

  /// The lowest heart rate in the interval, bpm
  final double? min;

  /// The highest heart rate in the interval, bpm
  final double? max;

  /// Continuous measurements within the interval
  final List<HeartRateSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'heartRate': heartRate,
        'min': min,
        'max': max,
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  HeartRateHarmonized.fromJson(Map<String, dynamic> json)
      : heartRate = parseDouble(json['heartRate']),
        min = tryParseDouble(json['min']),
        max = tryParseDouble(json['max']),
        series = parseObjects(json['series'], HeartRateSeries.fromJson);
}

/// Equivalent of [HeartRate.Series]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One continuous heart rate measurement, in beats per minute.
///
/// Supports [map] representation.
///
/// Has a [HeartRateSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeartRateSeries with Payload {
  const HeartRateSeries({
    required this.heartRate,
    required this.min,
    required this.max,
    required this.startTimestamp,
    required this.endTimestamp,
  });

  /// The heart rate, bpm
  final double heartRate;

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
        'heartRate': heartRate,
        'min': min,
        'max': max,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
      };

  /// General constructor from JSON payload
  ///
  HeartRateSeries.fromJson(Map<String, dynamic> json)
      : heartRate = parseDouble(json['heartRate']),
        min = parseDouble(json['min']),
        max = parseDouble(json['max']),
        startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']);
}
