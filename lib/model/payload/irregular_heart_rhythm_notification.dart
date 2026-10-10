import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/irregular_heart_rhythm_status.dart';
import 'sample.dart';

/// Equivalent of [IrregularHeartRhythmNotification]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// An irregular heart rhythm notification. Read-only.
///
/// Supports [map] representation.
///
/// Has a [IrregularHeartRhythmNotification.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.irregularHeartRhythmNotification] permissions provided.
///
class IrregularHeartRhythmNotification
    extends Sample<IrregularHeartRhythmNotificationHarmonized> {
  const IrregularHeartRhythmNotification({
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
  HealthType get healthType => HealthType.irregularHeartRhythmNotification;

  /// General constructor from JSON payload
  ///
  IrregularHeartRhythmNotification.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            IrregularHeartRhythmNotificationHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<IrregularHeartRhythmNotification> collect(List<dynamic> list) =>
      parseObjects(list, IrregularHeartRhythmNotification.fromJson);
}

/// Equivalent of [IrregularHeartRhythmNotification.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of IrregularHeartRhythmNotification.
///
/// Supports [map] representation.
///
/// Has a [IrregularHeartRhythmNotificationHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class IrregularHeartRhythmNotificationHarmonized with Payload {
  const IrregularHeartRhythmNotificationHarmonized({
    required this.status,
  });

  /// The detection status
  final IrregularHeartRhythmStatus status;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'status': status.value,
      };

  /// General constructor from JSON payload
  ///
  IrregularHeartRhythmNotificationHarmonized.fromJson(Map<String, dynamic> json)
      : status = IrregularHeartRhythmStatusFactory.from(json['status']);
}
