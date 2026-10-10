import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BloodPressure]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A blood pressure measurement, in mmHg.
///
/// Supports [map] representation.
///
/// Has a [BloodPressure.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bloodPressure] permissions provided.
///
class BloodPressure extends WritableSample<BloodPressureHarmonized> {
  const BloodPressure({
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
  HealthType get healthType => HealthType.bloodPressure;

  /// General constructor from JSON payload
  ///
  BloodPressure.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            BloodPressureHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BloodPressure> collect(List<dynamic> list) =>
      parseObjects(list, BloodPressure.fromJson);
}

/// Equivalent of [BloodPressure.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of BloodPressure.
///
/// Supports [map] representation.
///
/// Has a [BloodPressureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodPressureHarmonized with Payload {
  const BloodPressureHarmonized({
    required this.systolic,
    required this.diastolic,
    required this.mean,
    this.pulseRate,
    this.medicationTaken,
  });

  /// Systolic pressure in mmHg (0–300)
  final double systolic;

  /// Diastolic pressure in mmHg (0–250)
  final double diastolic;

  /// Mean pressure in mmHg (0–300)
  final double mean;

  /// Pulse rate in beats per minute (15–300)
  final int? pulseRate;

  /// Medication was taken before the measurement
  final bool? medicationTaken;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'systolic': systolic,
        'diastolic': diastolic,
        'mean': mean,
        'pulseRate': pulseRate,
        'medicationTaken': medicationTaken,
      };

  /// General constructor from JSON payload
  ///
  BloodPressureHarmonized.fromJson(Map<String, dynamic> json)
      : systolic = parseDouble(json['systolic']),
        diastolic = parseDouble(json['diastolic']),
        mean = parseDouble(json['mean']),
        pulseRate = tryParseInt(json['pulseRate']),
        medicationTaken = json['medicationTaken'];
}
