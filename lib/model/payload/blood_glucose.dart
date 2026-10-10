import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/glucose_measurement_type.dart';
import '../type/glucose_sample_source.dart';
import '../type/meal_status.dart';
import 'sample.dart';

/// Equivalent of [BloodGlucose]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A blood glucose measurement, in mmol/L.
///
/// Supports [map] representation.
///
/// Has a [BloodGlucose.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bloodGlucose] permissions provided.
///
class BloodGlucose extends WritableSample<BloodGlucoseHarmonized> {
  const BloodGlucose({
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
  HealthType get healthType => HealthType.bloodGlucose;

  /// General constructor from JSON payload
  ///
  BloodGlucose.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            BloodGlucoseHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BloodGlucose> collect(List<dynamic> list) =>
      parseObjects(list, BloodGlucose.fromJson);
}

/// Equivalent of [BloodGlucose.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of BloodGlucose.
///
/// Supports [map] representation.
///
/// Has a [BloodGlucoseHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodGlucoseHarmonized with Payload {
  const BloodGlucoseHarmonized({
    required this.glucoseLevel,
    required this.mealStatus,
    required this.measurementType,
    this.sampleSource,
    this.insulinInjected,
    this.mealTimestamp,
    this.medicationTaken,
    this.series = const [],
  });

  /// Blood glucose in mmol/L (1–40)
  final double glucoseLevel;

  /// Meal status at the time of measurement
  final MealStatus mealStatus;

  /// The type of blood measured
  final GlucoseMeasurementType measurementType;

  /// Where the sample was taken
  final GlucoseSampleSource? sampleSource;

  /// Insulin injected before the measurement (0–100)
  final double? insulinInjected;

  /// Meal time, epoch milliseconds
  final int? mealTimestamp;

  /// Medication was taken before the measurement
  final bool? medicationTaken;

  /// Continuous glucose levels
  final List<BloodGlucoseSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'glucoseLevel': glucoseLevel,
        'mealStatus': mealStatus.value,
        'measurementType': measurementType.value,
        'sampleSource': sampleSource?.value,
        'insulinInjected': insulinInjected,
        'mealTimestamp': mealTimestamp,
        'medicationTaken': medicationTaken,
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  BloodGlucoseHarmonized.fromJson(Map<String, dynamic> json)
      : glucoseLevel = parseDouble(json['glucoseLevel']),
        mealStatus = MealStatusFactory.from(json['mealStatus']),
        measurementType =
            GlucoseMeasurementTypeFactory.from(json['measurementType']),
        sampleSource = json['sampleSource'] == null
            ? null
            : GlucoseSampleSourceFactory.from(json['sampleSource']),
        insulinInjected = tryParseDouble(json['insulinInjected']),
        mealTimestamp = tryParseInt(json['mealTimestamp']),
        medicationTaken = json['medicationTaken'],
        series = parseObjects(json['series'], BloodGlucoseSeries.fromJson);
}

/// Equivalent of [BloodGlucose.Series]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One continuous glucose level.
///
/// Supports [map] representation.
///
/// Has a [BloodGlucoseSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodGlucoseSeries with Payload {
  const BloodGlucoseSeries({
    required this.glucose,
    required this.timestamp,
  });

  /// Blood glucose in mmol/L
  final double glucose;

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'glucose': glucose,
        'timestamp': timestamp,
      };

  /// General constructor from JSON payload
  ///
  BloodGlucoseSeries.fromJson(Map<String, dynamic> json)
      : glucose = parseDouble(json['glucose']),
        timestamp = parseInt(json['timestamp']);
}
