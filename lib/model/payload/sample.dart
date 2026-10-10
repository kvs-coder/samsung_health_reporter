import '../../exceptions.dart';
import 'payload.dart';
import '../data_source.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'blood_glucose.dart';
import 'blood_oxygen.dart';
import 'blood_pressure.dart';
import 'body_composition.dart';
import 'body_temperature.dart';
import 'energy_score.dart';
import 'exercise.dart';
import 'floors_climbed.dart';
import 'heart_rate.dart';
import 'irregular_heart_rhythm_notification.dart';
import 'nutrition.dart';
import 'skin_temperature.dart';
import 'sleep.dart';
import 'sleep_apnea.dart';
import 'water_intake.dart';

/// Equivalent of [Sample]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One data point stored in Samsung Health. In JSON a sample carries
/// a `type` discriminator with its [healthType] identifier, e.g. `heart_rate`.
///
/// Supports [map] representation.
///
/// Has a [Sample.from] constructor
/// to create instances from JSON payload coming from Android native code
/// and a generic Harmonized object.
///
/// Has a [factory] method for creating a specific instance of types:
/// - [HeartRate]
/// - [BloodOxygen]
/// - [BloodPressure]
/// - [BloodGlucose]
/// - [BodyComposition]
/// - [BodyTemperature]
/// - [SkinTemperature]
/// - [Exercise]
/// - [FloorsClimbed]
/// - [Sleep]
/// - [Nutrition]
/// - [WaterIntake]
/// - [EnergyScore]
/// - [IrregularHeartRhythmNotification]
/// - [SleepApnea]
///
abstract class Sample<Harmonized extends Payload> with Payload {
  const Sample({
    required this.startTimestamp,
    required this.harmonized,
    this.uid,
    this.clientDataId,
    this.zoneOffsetSeconds,
    this.dataSource,
  });

  /// Start time, epoch milliseconds
  final int startTimestamp;

  /// End time, epoch milliseconds; null for instantaneous measurements
  int? get endTimestamp;

  /// The measured values
  final Harmonized harmonized;

  /// Samsung Health id of the stored data point; null until it is inserted
  final String? uid;

  /// Your own id for the data point (1–36 characters), kept by Samsung Health
  final String? clientDataId;

  /// Zone offset of the measurement in seconds;
  /// null means the device's current offset
  final int? zoneOffsetSeconds;

  /// The app and device that wrote the data point; null until it is inserted
  final DataSource? dataSource;

  /// The data type of this sample
  HealthType get healthType;

  /// General map representation, with the `type` discriminator
  ///
  @override
  Map<String, dynamic> get map => {
        'type': healthType.identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'harmonized': harmonized.map,
        'uid': uid,
        'clientDataId': clientDataId,
        'zoneOffsetSeconds': zoneOffsetSeconds,
        'dataSource': dataSource?.map,
      };

  /// General constructor from JSON payload
  ///
  Sample.from(Map<String, dynamic> json, this.harmonized)
      : startTimestamp = parseInt(json['startTimestamp']),
        uid = json['uid'],
        clientDataId = json['clientDataId'],
        zoneOffsetSeconds = tryParseInt(json['zoneOffsetSeconds']),
        dataSource = DataSource.tryFromJson(json['dataSource']);

  /// Factory method to create the sample its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type or a type
  /// that has no samples, so no sample is dropped silently.
  ///
  static Sample factory(Map<String, dynamic> json) {
    final type = json['type'];
    final healthType = type is String ? HealthTypeFactory.tryFrom(type) : null;
    switch (healthType) {
      case HealthType.heartRate:
        return HeartRate.fromJson(json);
      case HealthType.bloodOxygen:
        return BloodOxygen.fromJson(json);
      case HealthType.bloodPressure:
        return BloodPressure.fromJson(json);
      case HealthType.bloodGlucose:
        return BloodGlucose.fromJson(json);
      case HealthType.bodyComposition:
        return BodyComposition.fromJson(json);
      case HealthType.bodyTemperature:
        return BodyTemperature.fromJson(json);
      case HealthType.skinTemperature:
        return SkinTemperature.fromJson(json);
      case HealthType.exercise:
        return Exercise.fromJson(json);
      case HealthType.floorsClimbed:
        return FloorsClimbed.fromJson(json);
      case HealthType.sleep:
        return Sleep.fromJson(json);
      case HealthType.nutrition:
        return Nutrition.fromJson(json);
      case HealthType.waterIntake:
        return WaterIntake.fromJson(json);
      case HealthType.energyScore:
        return EnergyScore.fromJson(json);
      case HealthType.irregularHeartRhythmNotification:
        return IrregularHeartRhythmNotification.fromJson(json);
      case HealthType.sleepApnea:
        return SleepApnea.fromJson(json);
      case HealthType.steps:
      case HealthType.stepsGoal:
      case HealthType.activitySummary:
      case HealthType.activeCaloriesBurnedGoal:
      case HealthType.activeTimeGoal:
      case HealthType.exerciseLocation:
      case HealthType.sleepGoal:
      case HealthType.nutritionGoal:
      case HealthType.waterIntakeGoal:
      case HealthType.userProfile:
        throw InvalidValueException('No samples of type: $type');
      case null:
        throw InvalidValueException('Unknown sample type: $type');
    }
  }

  /// [factory] for a list of samples, given as maps or JSON strings.
  ///
  static List<Sample> collect(List<dynamic> list) =>
      parseObjects(list, factory);
}

/// Equivalent of [WritableSample]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A sample type apps may insert, update and delete.
///
abstract class WritableSample<Harmonized extends Payload>
    extends Sample<Harmonized> {
  const WritableSample({
    required super.startTimestamp,
    required super.harmonized,
    super.uid,
    super.clientDataId,
    super.zoneOffsetSeconds,
    super.dataSource,
  });

  /// General constructor from JSON payload
  ///
  WritableSample.from(super.json, super.harmonized) : super.from();
}
