import 'payload/payload.dart';
import 'decorator/extensions.dart';

/// Equivalent of [DataSource]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The app and device that wrote a data point.
///
/// Supports [map] representation.
///
/// Has a [DataSource.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class DataSource with Payload {
  const DataSource({
    required this.appId,
    required this.deviceId,
  });

  /// Package name of the writing app;
  /// `com.sec.android.app.shealth` for Samsung Health
  final String appId;

  /// Samsung Health device id, as in [Device.id]
  final String deviceId;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'appId': appId,
        'deviceId': deviceId,
      };

  /// General constructor from JSON payload
  ///
  DataSource.fromJson(Map<String, dynamic> json)
      : appId = json['appId'],
        deviceId = json['deviceId'];

  /// [DataSource.fromJson] for optional fields.
  ///
  static DataSource? tryFromJson(dynamic json) =>
      json == null ? null : DataSource.fromJson(parseObject(json));
}
