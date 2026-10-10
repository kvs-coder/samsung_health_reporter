import '../exceptions.dart';
import 'payload/payload.dart';

/// Equivalent of [SourceFilter]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Limits reads to data from one source:
/// - [SourceFilter.app] data written by the app with a package name
/// - [SourceFilter.localDevice] data measured on this phone
/// - [SourceFilter.samsungHealth] data written by Samsung Health itself
///
/// Supports [map] representation, `{'source': 'app', 'appId': ...}`,
/// `{'source': 'localDevice'}` or `{'source': 'samsungHealth'}`.
///
/// Has a [SourceFilter.fromJson] constructor to read the [map] back.
///
sealed class SourceFilter with Payload {
  const SourceFilter();

  /// Data written by the app with package name [appId]
  ///
  const factory SourceFilter.app(String appId) = SourceFilterApp;

  /// Data measured on this phone
  ///
  static const SourceFilter localDevice = SourceFilterLocalDevice();

  /// Data written by Samsung Health itself
  ///
  static const SourceFilter samsungHealth = SourceFilterSamsungHealth();

  /// General constructor from the [map] representation.
  /// Throws an [InvalidValueException] for an unknown source.
  ///
  factory SourceFilter.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    switch (source) {
      case 'app':
        return SourceFilterApp(json['appId']);
      case 'localDevice':
        return localDevice;
      case 'samsungHealth':
        return samsungHealth;
      default:
        throw InvalidValueException('Unknown SourceFilter source: $source');
    }
  }
}

/// Equivalent of [SourceFilter.App]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Data written by the app with package name [appId].
///
class SourceFilterApp extends SourceFilter {
  const SourceFilterApp(this.appId);

  /// Package name of the writing app
  final String appId;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'source': 'app',
        'appId': appId,
      };
}

/// Equivalent of [SourceFilter.LocalDevice]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Data measured on this phone.
///
class SourceFilterLocalDevice extends SourceFilter {
  const SourceFilterLocalDevice();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {'source': 'localDevice'};
}

/// Equivalent of [SourceFilter.SamsungHealth]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// Data written by Samsung Health itself.
///
class SourceFilterSamsungHealth extends SourceFilter {
  const SourceFilterSamsungHealth();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {'source': 'samsungHealth'};
}
