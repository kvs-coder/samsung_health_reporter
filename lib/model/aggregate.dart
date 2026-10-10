import 'payload/payload.dart';
import 'decorator/extensions.dart';
import 'type/aggregation.dart';

/// Equivalent of [Aggregate]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One aggregated value for a time bucket. In JSON the [aggregation]
/// is its [Aggregation.value], e.g. `STEPS_TOTAL`.
///
/// Supports [map] representation.
///
/// Has a [Aggregate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class Aggregate with Payload {
  /// [unit] is the [Aggregation.unit] by default.
  ///
  Aggregate({
    required this.aggregation,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.value,
    String? unit,
  }) : unit = unit ?? aggregation.unit;

  /// The operation
  final Aggregation aggregation;

  /// Bucket start, epoch milliseconds
  final int startTimestamp;

  /// Bucket end, epoch milliseconds
  final int endTimestamp;

  /// The value in [unit]; null when Samsung Health has no data for the bucket
  final double? value;

  /// Unit of [value]
  final String unit;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'aggregation': aggregation.value,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'value': value,
        'unit': unit,
      };

  /// General constructor from JSON payload
  ///
  factory Aggregate.fromJson(Map<String, dynamic> json) => Aggregate(
        aggregation: AggregationFactory.from(json['aggregation']),
        startTimestamp: parseInt(json['startTimestamp']),
        endTimestamp: parseInt(json['endTimestamp']),
        value: tryParseDouble(json['value']),
        unit: json['unit'],
      );

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Aggregate> collect(List<dynamic> list) =>
      parseObjects(list, Aggregate.fromJson);
}
