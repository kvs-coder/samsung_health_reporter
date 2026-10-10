import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/sleep_apnea_sign.dart';
import 'sample.dart';

/// Equivalent of [SleepApnea]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A sleep apnea check result. Read-only.
///
/// Supports [map] representation.
///
/// Has a [SleepApnea.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.sleepApnea] permissions provided.
///
class SleepApnea extends Sample<SleepApneaHarmonized> {
  const SleepApnea({
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
  HealthType get healthType => HealthType.sleepApnea;

  /// General constructor from JSON payload
  ///
  SleepApnea.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            SleepApneaHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<SleepApnea> collect(List<dynamic> list) =>
      parseObjects(list, SleepApnea.fromJson);
}

/// Equivalent of [SleepApnea.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of SleepApnea.
///
/// Supports [map] representation.
///
/// Has a [SleepApneaHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepApneaHarmonized with Payload {
  const SleepApneaHarmonized({
    required this.detectedSign,
  });

  /// The detected sign
  final SleepApneaSign detectedSign;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'detectedSign': detectedSign.value,
      };

  /// General constructor from JSON payload
  ///
  SleepApneaHarmonized.fromJson(Map<String, dynamic> json)
      : detectedSign = SleepApneaSignFactory.from(json['detectedSign']);
}
