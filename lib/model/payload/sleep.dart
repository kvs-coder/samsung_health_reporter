import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/sleep_stage_type.dart';
import 'sample.dart';

/// Equivalent of [Sleep]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One sleep record made of one or more sessions.
/// Samsung Health requires [startTimestamp] and [endTimestamp] to match
/// the first session's start and the last session's end, and sessions not to overlap.
///
/// Supports [map] representation.
///
/// Has a [Sleep.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.sleep] permissions provided.
///
class Sleep extends WritableSample<SleepHarmonized> {
  const Sleep({
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
  HealthType get healthType => HealthType.sleep;

  /// General constructor from JSON payload
  ///
  Sleep.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, SleepHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Sleep> collect(List<dynamic> list) =>
      parseObjects(list, Sleep.fromJson);
}

/// Equivalent of [Sleep.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of Sleep.
///
/// Supports [map] representation.
///
/// Has a [SleepHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepHarmonized with Payload {
  const SleepHarmonized({
    required this.durationMillis,
    required this.sessions,
    this.sleepScore,
  });

  /// Sleep duration in milliseconds (up to 1440 minutes)
  final int durationMillis;

  /// The sleep sessions, at least one
  final List<SleepSession> sessions;

  /// Overall sleep quality (0–100); computed by Samsung Health, ignored on writes
  final int? sleepScore;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'durationMillis': durationMillis,
        'sessions': sessions.map((e) => e.map).toList(),
        'sleepScore': sleepScore,
      };

  /// General constructor from JSON payload
  ///
  SleepHarmonized.fromJson(Map<String, dynamic> json)
      : durationMillis = parseInt(json['durationMillis']),
        sessions = parseObjects(json['sessions'], SleepSession.fromJson),
        sleepScore = tryParseInt(json['sleepScore']);
}

/// Equivalent of [Sleep.Session]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One period from bedtime to wake-up.
///
/// Supports [map] representation.
///
/// Has a [SleepSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepSession with Payload {
  const SleepSession({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.durationMillis,
    this.stages = const [],
  });

  /// Bedtime, epoch milliseconds
  final int startTimestamp;

  /// Wake-up time, epoch milliseconds
  final int endTimestamp;

  /// Duration in milliseconds
  final int durationMillis;

  /// The recorded sleep stages
  final List<SleepStage> stages;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'durationMillis': durationMillis,
        'stages': stages.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  SleepSession.fromJson(Map<String, dynamic> json)
      : startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        durationMillis = parseInt(json['durationMillis']),
        stages = parseObjects(json['stages'], SleepStage.fromJson);
}

/// Equivalent of [Sleep.Stage]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One sleep stage.
///
/// Supports [map] representation.
///
/// Has a [SleepStage.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepStage with Payload {
  const SleepStage({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.stage,
  });

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds
  final int endTimestamp;

  /// The stage
  final SleepStageType stage;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'stage': stage.value,
      };

  /// General constructor from JSON payload
  ///
  SleepStage.fromJson(Map<String, dynamic> json)
      : startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        stage = SleepStageTypeFactory.from(json['stage']);
}
