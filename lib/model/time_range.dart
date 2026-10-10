import '../exceptions.dart';
import 'payload/payload.dart';
import 'decorator/extensions.dart';

/// Equivalent of [TimeRange]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A time range in epoch milliseconds, end exclusive. Reads and aggregates
/// interpret it in the device's local time, the way Samsung Health shows data.
///
/// Throws an [InvalidValueException] when [end] is not after [start].
///
/// Supports [map] representation.
///
/// Has a [TimeRange.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TimeRange with Payload {
  TimeRange({
    required this.start,
    required this.end,
  }) {
    if (end <= start) {
      throw InvalidValueException(
          'Invalid TimeRange: end $end is not after start $start');
    }
  }

  /// The range from [start] to [end] in epoch milliseconds.
  ///
  TimeRange.fromDates(DateTime start, DateTime end)
      : this(
          start: start.millisecondsSinceEpoch,
          end: end.millisecondsSinceEpoch,
        );

  /// Epoch milliseconds, inclusive
  final int start;

  /// Epoch milliseconds, exclusive
  final int end;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'start': start,
        'end': end,
      };

  /// General constructor from JSON payload
  ///
  TimeRange.fromJson(Map<String, dynamic> json)
      : this(
          start: parseInt(json['start']),
          end: parseInt(json['end']),
        );
}
