import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BodyComposition]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Weight and body composition.
///
/// Supports [map] representation.
///
/// Has a [BodyComposition.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bodyComposition] permissions provided.
///
class BodyComposition extends WritableSample<BodyCompositionHarmonized> {
  const BodyComposition({
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
  HealthType get healthType => HealthType.bodyComposition;

  /// General constructor from JSON payload
  ///
  BodyComposition.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            BodyCompositionHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BodyComposition> collect(List<dynamic> list) =>
      parseObjects(list, BodyComposition.fromJson);
}

/// Equivalent of [BodyComposition.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of BodyComposition.
///
/// Supports [map] representation.
///
/// Has a [BodyCompositionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BodyCompositionHarmonized with Payload {
  const BodyCompositionHarmonized({
    required this.weight,
    this.height,
    this.bodyFat,
    this.bodyFatMass,
    this.bodyMassIndex,
    this.fatFree,
    this.fatFreeMass,
    this.muscleMass,
    this.skeletalMuscle,
    this.skeletalMuscleMass,
    this.totalBodyWater,
    this.basalMetabolicRate,
  });

  /// Weight in kilograms (2–500)
  final double weight;

  /// Height in centimeters (20–300)
  final double? height;

  /// Body fat in percent (0–100)
  final double? bodyFat;

  /// Body fat mass in kilograms (2–500)
  final double? bodyFatMass;

  /// Body mass index (0–90), calculated by Samsung Health
  final double? bodyMassIndex;

  /// Fat-free mass in percent (0–100)
  final double? fatFree;

  /// Fat-free mass in kilograms (2–500)
  final double? fatFreeMass;

  /// Muscle mass in percent (10–99)
  final double? muscleMass;

  /// Skeletal muscle in percent (0–100)
  final double? skeletalMuscle;

  /// Skeletal muscle mass in kilograms (2–500)
  final double? skeletalMuscleMass;

  /// Total body water in liters (2–500)
  final double? totalBodyWater;

  /// Basal metabolic rate in kilocalories per day (100–12000)
  final int? basalMetabolicRate;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'weight': weight,
        'height': height,
        'bodyFat': bodyFat,
        'bodyFatMass': bodyFatMass,
        'bodyMassIndex': bodyMassIndex,
        'fatFree': fatFree,
        'fatFreeMass': fatFreeMass,
        'muscleMass': muscleMass,
        'skeletalMuscle': skeletalMuscle,
        'skeletalMuscleMass': skeletalMuscleMass,
        'totalBodyWater': totalBodyWater,
        'basalMetabolicRate': basalMetabolicRate,
      };

  /// General constructor from JSON payload
  ///
  BodyCompositionHarmonized.fromJson(Map<String, dynamic> json)
      : weight = parseDouble(json['weight']),
        height = tryParseDouble(json['height']),
        bodyFat = tryParseDouble(json['bodyFat']),
        bodyFatMass = tryParseDouble(json['bodyFatMass']),
        bodyMassIndex = tryParseDouble(json['bodyMassIndex']),
        fatFree = tryParseDouble(json['fatFree']),
        fatFreeMass = tryParseDouble(json['fatFreeMass']),
        muscleMass = tryParseDouble(json['muscleMass']),
        skeletalMuscle = tryParseDouble(json['skeletalMuscle']),
        skeletalMuscleMass = tryParseDouble(json['skeletalMuscleMass']),
        totalBodyWater = tryParseDouble(json['totalBodyWater']),
        basalMetabolicRate = tryParseInt(json['basalMetabolicRate']);
}
