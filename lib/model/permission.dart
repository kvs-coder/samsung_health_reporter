import 'payload/payload.dart';
import 'decorator/extensions.dart';
import 'type/access_type.dart';
import 'type/health_type.dart';

/// Equivalent of [Permission]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Access to one [type]. In JSON the [type] is its [HealthType.value],
/// e.g. `{"type": "HEART_RATE", "access": "READ"}`.
///
/// Supports [map] representation.
///
/// Has a [Permission.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class Permission with Payload {
  const Permission({
    required this.type,
    required this.access,
  });

  /// The data type
  final HealthType type;

  /// Read or write
  final AccessType access;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': type.value,
        'access': access.value,
      };

  /// General constructor from JSON payload
  ///
  Permission.fromJson(Map<String, dynamic> json)
      : type = HealthTypeFactory.fromValue(json['type']),
        access = AccessTypeFactory.from(json['access']);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Permission> collect(List<dynamic> list) =>
      parseObjects(list, Permission.fromJson);
}
