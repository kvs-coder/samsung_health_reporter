import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [EnergyScore]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The daily energy score. Read-only.
///
/// Supports [map] representation.
///
/// Has a [EnergyScore.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.energyScore] permissions provided.
///
class EnergyScore extends Sample<EnergyScoreHarmonized> {
  const EnergyScore({
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
  HealthType get healthType => HealthType.energyScore;

  /// General constructor from JSON payload
  ///
  EnergyScore.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            EnergyScoreHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<EnergyScore> collect(List<dynamic> list) =>
      parseObjects(list, EnergyScore.fromJson);
}

/// Equivalent of [EnergyScore.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of EnergyScore.
///
/// Supports [map] representation.
///
/// Has a [EnergyScoreHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class EnergyScoreHarmonized with Payload {
  const EnergyScoreHarmonized({
    required this.score,
  });

  /// Energy score (0–100)
  final double score;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'score': score,
      };

  /// General constructor from JSON payload
  ///
  EnergyScoreHarmonized.fromJson(Map<String, dynamic> json)
      : score = parseDouble(json['score']);
}
