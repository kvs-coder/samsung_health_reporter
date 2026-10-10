import 'payload/payload.dart';
import 'decorator/extensions.dart';

/// Equivalent of [Device]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A device registered in Samsung Health.
///
/// Supports [map] representation.
///
/// Has a [Device.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class Device with Payload {
  const Device({
    required this.id,
    required this.type,
    this.manufacturer,
    this.model,
    this.name,
  });

  /// Samsung Health device id, as in [DataSource.deviceId]
  final String id;

  /// Device group (`MOBILE`, `WATCH`, `RING`, `BAND`, `ACCESSORY`, `OTHER`)
  /// or accessory type (`WEIGHT_SCALE`, `HEART_RATE_MONITOR`, ...)
  final String type;
  final String? manufacturer;
  final String? model;

  /// Display name
  final String? name;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'id': id,
        'type': type,
        'manufacturer': manufacturer,
        'model': model,
        'name': name,
      };

  /// General constructor from JSON payload
  ///
  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        manufacturer = json['manufacturer'],
        model = json['model'],
        name = json['name'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Device> collect(List<dynamic> list) =>
      parseObjects(list, Device.fromJson);
}
