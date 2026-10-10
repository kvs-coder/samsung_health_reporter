import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/exercise_count_type.dart';
import '../type/exercise_type.dart';
import 'sample.dart';

/// Equivalent of [Exercise]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One workout made of one or more sessions.
/// Samsung Health requires [startTimestamp] and [endTimestamp] to match
/// the session times, and sessions not to overlap.
///
/// Supports [map] representation.
///
/// Has a [Exercise.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.exercise] permissions provided.
///
class Exercise extends WritableSample<ExerciseHarmonized> {
  const Exercise({
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
  HealthType get healthType => HealthType.exercise;

  /// General constructor from JSON payload
  ///
  Exercise.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, ExerciseHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Exercise> collect(List<dynamic> list) =>
      parseObjects(list, Exercise.fromJson);
}

/// Equivalent of [Exercise.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of Exercise.
///
/// Supports [map] representation.
///
/// Has a [ExerciseHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseHarmonized with Payload {
  const ExerciseHarmonized({
    required this.exerciseType,
    required this.sessions,
    this.customTitle,
  });

  /// The representative exercise type
  final ExerciseType exerciseType;

  /// The exercise sessions, at least one
  final List<ExerciseSession> sessions;

  /// Custom title when [exerciseType] is [ExerciseType.other]
  final String? customTitle;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'exerciseType': exerciseType.value,
        'sessions': sessions.map((e) => e.map).toList(),
        'customTitle': customTitle,
      };

  /// General constructor from JSON payload
  ///
  ExerciseHarmonized.fromJson(Map<String, dynamic> json)
      : exerciseType = ExerciseTypeFactory.from(json['exerciseType']),
        sessions = parseObjects(json['sessions'], ExerciseSession.fromJson),
        customTitle = json['customTitle'];
}

/// Equivalent of [Exercise.Session]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One exercise activity.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSession with Payload {
  const ExerciseSession({
    required this.exerciseType,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.durationMillis,
    required this.calories,
    this.customTitle,
    this.comment,
    this.distance,
    this.count,
    this.countType,
    this.altitudeGain,
    this.altitudeLoss,
    this.maxAltitude,
    this.minAltitude,
    this.inclineDistance,
    this.declineDistance,
    this.maxCadence,
    this.meanCadence,
    this.maxCalorieBurnRate,
    this.meanCalorieBurnRate,
    this.maxHeartRate,
    this.meanHeartRate,
    this.minHeartRate,
    this.maxPower,
    this.meanPower,
    this.maxRpm,
    this.meanRpm,
    this.maxSpeed,
    this.meanSpeed,
    this.vo2Max,
    this.log = const [],
    this.route = const [],
  });

  /// The activity
  final ExerciseType exerciseType;

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds
  final int endTimestamp;

  /// Duration in milliseconds (up to 2880 minutes)
  final int durationMillis;

  /// Burned calories in kilocalories
  final double calories;

  /// Custom title when [exerciseType] is [ExerciseType.other] (1–255 characters)
  final String? customTitle;

  /// Comment (0–255 characters)
  final String? comment;

  /// Distance in meters
  final double? distance;

  /// Count of a countable exercise, see [countType]
  final int? count;

  /// What [count] measures
  final ExerciseCountType? countType;

  /// Altitude gain in meters
  final double? altitudeGain;

  /// Altitude loss in meters
  final double? altitudeLoss;

  /// Highest altitude in meters
  final double? maxAltitude;

  /// Lowest altitude in meters
  final double? minAltitude;

  /// Uphill distance in meters
  final double? inclineDistance;

  /// Downhill distance in meters
  final double? declineDistance;

  /// Highest cadence per minute
  final double? maxCadence;

  /// Mean cadence per minute
  final double? meanCadence;

  /// Highest calorie burn rate in kilocalories per hour
  final double? maxCalorieBurnRate;

  /// Mean calorie burn rate in kilocalories per hour
  final double? meanCalorieBurnRate;

  /// Highest heart rate in beats per minute
  final double? maxHeartRate;

  /// Mean heart rate in beats per minute
  final double? meanHeartRate;

  /// Lowest heart rate in beats per minute
  final double? minHeartRate;

  /// Highest power in watts
  final double? maxPower;

  /// Mean power in watts
  final double? meanPower;

  /// Highest revolutions per minute
  final double? maxRpm;

  /// Mean revolutions per minute
  final double? meanRpm;

  /// Highest speed in meters per second
  final double? maxSpeed;

  /// Mean speed in meters per second
  final double? meanSpeed;

  /// VO2 max in mL/kg/min
  final double? vo2Max;

  /// Periodic measurements during the session
  final List<ExerciseLog> log;

  /// The route; needs the [HealthType.exerciseLocation] read permission
  final List<ExerciseLocation> route;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'exerciseType': exerciseType.value,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'durationMillis': durationMillis,
        'calories': calories,
        'customTitle': customTitle,
        'comment': comment,
        'distance': distance,
        'count': count,
        'countType': countType?.value,
        'altitudeGain': altitudeGain,
        'altitudeLoss': altitudeLoss,
        'maxAltitude': maxAltitude,
        'minAltitude': minAltitude,
        'inclineDistance': inclineDistance,
        'declineDistance': declineDistance,
        'maxCadence': maxCadence,
        'meanCadence': meanCadence,
        'maxCalorieBurnRate': maxCalorieBurnRate,
        'meanCalorieBurnRate': meanCalorieBurnRate,
        'maxHeartRate': maxHeartRate,
        'meanHeartRate': meanHeartRate,
        'minHeartRate': minHeartRate,
        'maxPower': maxPower,
        'meanPower': meanPower,
        'maxRpm': maxRpm,
        'meanRpm': meanRpm,
        'maxSpeed': maxSpeed,
        'meanSpeed': meanSpeed,
        'vo2Max': vo2Max,
        'log': log.map((e) => e.map).toList(),
        'route': route.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  ExerciseSession.fromJson(Map<String, dynamic> json)
      : exerciseType = ExerciseTypeFactory.from(json['exerciseType']),
        startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        durationMillis = parseInt(json['durationMillis']),
        calories = parseDouble(json['calories']),
        customTitle = json['customTitle'],
        comment = json['comment'],
        distance = tryParseDouble(json['distance']),
        count = tryParseInt(json['count']),
        countType = json['countType'] == null
            ? null
            : ExerciseCountTypeFactory.from(json['countType']),
        altitudeGain = tryParseDouble(json['altitudeGain']),
        altitudeLoss = tryParseDouble(json['altitudeLoss']),
        maxAltitude = tryParseDouble(json['maxAltitude']),
        minAltitude = tryParseDouble(json['minAltitude']),
        inclineDistance = tryParseDouble(json['inclineDistance']),
        declineDistance = tryParseDouble(json['declineDistance']),
        maxCadence = tryParseDouble(json['maxCadence']),
        meanCadence = tryParseDouble(json['meanCadence']),
        maxCalorieBurnRate = tryParseDouble(json['maxCalorieBurnRate']),
        meanCalorieBurnRate = tryParseDouble(json['meanCalorieBurnRate']),
        maxHeartRate = tryParseDouble(json['maxHeartRate']),
        meanHeartRate = tryParseDouble(json['meanHeartRate']),
        minHeartRate = tryParseDouble(json['minHeartRate']),
        maxPower = tryParseDouble(json['maxPower']),
        meanPower = tryParseDouble(json['meanPower']),
        maxRpm = tryParseDouble(json['maxRpm']),
        meanRpm = tryParseDouble(json['meanRpm']),
        maxSpeed = tryParseDouble(json['maxSpeed']),
        meanSpeed = tryParseDouble(json['meanSpeed']),
        vo2Max = tryParseDouble(json['vo2Max']),
        log = parseObjects(json['log'], ExerciseLog.fromJson),
        route = parseObjects(json['route'], ExerciseLocation.fromJson);
}

/// Equivalent of [Exercise.Log]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One periodic measurement during a session.
///
/// Supports [map] representation.
///
/// Has a [ExerciseLog.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseLog with Payload {
  const ExerciseLog({
    required this.timestamp,
    this.heartRate,
    this.cadence,
    this.count,
    this.power,
    this.speed,
  });

  /// Epoch milliseconds, within the session
  final int timestamp;

  /// Heart rate in beats per minute
  final double? heartRate;

  /// Cadence per minute
  final double? cadence;

  final int? count;

  /// Power in watts
  final double? power;

  /// Speed in meters per second
  final double? speed;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'heartRate': heartRate,
        'cadence': cadence,
        'count': count,
        'power': power,
        'speed': speed,
      };

  /// General constructor from JSON payload
  ///
  ExerciseLog.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        heartRate = tryParseDouble(json['heartRate']),
        cadence = tryParseDouble(json['cadence']),
        count = tryParseInt(json['count']),
        power = tryParseDouble(json['power']),
        speed = tryParseDouble(json['speed']);
}

/// Equivalent of [Exercise.Location]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One route point during a session.
///
/// Supports [map] representation.
///
/// Has a [ExerciseLocation.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseLocation with Payload {
  const ExerciseLocation({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
  });

  /// Epoch milliseconds, within the session
  final int timestamp;

  /// Latitude in degrees
  final double latitude;

  /// Longitude in degrees
  final double longitude;

  /// Altitude in meters
  final double? altitude;

  /// Accuracy in meters
  final double? accuracy;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'accuracy': accuracy,
      };

  /// General constructor from JSON payload
  ///
  ExerciseLocation.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        latitude = parseDouble(json['latitude']),
        longitude = parseDouble(json['longitude']),
        altitude = tryParseDouble(json['altitude']),
        accuracy = tryParseDouble(json['accuracy']);
}
