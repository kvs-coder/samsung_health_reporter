import 'payload/payload.dart';
import 'decorator/extensions.dart';
import 'payload/sample.dart';
import 'type/health_type.dart';

/// Equivalent of [ChangeSet]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The changes Samsung Health recorded for one type in a time window.
/// Persist [until] and pass it as `since` to the next changes read.
/// In JSON the [type] is its [HealthType.value], e.g. `HEART_RATE`.
///
/// Supports [map] representation.
///
/// Has a [ChangeSet.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ChangeSet with Payload {
  const ChangeSet({
    required this.type,
    required this.since,
    required this.until,
    required this.upserted,
    required this.deletedUids,
  });

  /// The observed type
  final HealthType type;

  /// Window start, epoch milliseconds
  final int since;

  /// Window end, epoch milliseconds
  final int until;

  /// Inserted or updated data points
  final List<Sample> upserted;

  /// Uids of deleted data points
  final List<String> deletedUids;

  /// True when nothing changed
  bool get isEmpty => upserted.isEmpty && deletedUids.isEmpty;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': type.value,
        'since': since,
        'until': until,
        'upserted': upserted.map((e) => e.map).toList(),
        'deletedUids': deletedUids,
      };

  /// General constructor from JSON payload.
  /// Throws an [InvalidValueException] for a sample of an unknown type.
  ///
  ChangeSet.fromJson(Map<String, dynamic> json)
      : type = HealthTypeFactory.fromValue(json['type']),
        since = parseInt(json['since']),
        until = parseInt(json['until']),
        upserted = Sample.collect(json['upserted'] ?? const []),
        deletedUids = parseStrings(json['deletedUids']);
}
