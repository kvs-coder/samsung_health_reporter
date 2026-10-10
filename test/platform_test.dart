import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/samsung_health_reporter.dart';

/// Samsung Health is available only on Android: elsewhere nothing reaches the channel.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('samsung_health_reporter_method_channel'),
            (call) async {
      calls.add(call.method);
      return true;
    });
  });
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
    group('on ${platform.name}', () {
      setUp(() => debugDefaultTargetPlatformOverride = platform);

      test('is_available_is_false_without_a_channel_call', () async {
        expect(await SamsungHealthReporter.isAvailable(), isFalse);
        expect(calls, isEmpty);
      });

      test('methods_throw_unsupported_error_naming_the_platforms', () {
        expect(
            () => SamsungHealthReporter.isAuthorized(),
            throwsA(isA<UnsupportedError>().having(
                (e) => e.message,
                'message',
                'Samsung Health is available only on android, not on '
                    '${platform.name}')));
        expect(calls, isEmpty);
      });

      test('observe_throws_before_subscribing', () {
        expect(
            () => SamsungHealthReporter.observe(HealthType.heartRate, 0,
                onUpdate: (_) {}),
            throwsUnsupportedError);
        expect(calls, isEmpty);
      });
    });
  }

  test('on_android_calls_reach_the_channel', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(await SamsungHealthReporter.isAvailable(), isTrue);
    expect(await SamsungHealthReporter.resolve(), isTrue);
    expect(calls, ['isAvailable', 'resolve']);
  });
}
