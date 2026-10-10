import 'package:flutter/foundation.dart';

/// Samsung Health is available only on Android.
///
/// Whether the app runs on [platform]; never on the web.
///
bool runsOn(TargetPlatform platform) =>
    !kIsWeb && defaultTargetPlatform == platform;

/// Throws an [UnsupportedError] naming [provider] and [platform]
/// unless the app runs on [platform], before any channel call.
///
void requirePlatform(TargetPlatform platform, String provider) {
  if (!runsOn(platform)) {
    throw UnsupportedError(
        '$provider is available only on ${platform.name}, not on '
        '${kIsWeb ? 'the web' : defaultTargetPlatform.name}');
  }
}
