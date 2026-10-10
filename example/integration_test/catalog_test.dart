import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter_example/demo/catalog.dart';
import 'package:integration_test/integration_test.dart';

/// Runs every row of the Samsung Health demo on an Android phone.
/// Grant the read permissions once first (run the app, tap requestPermissions
/// and allow all), since Samsung Health's permission screen can't be driven
/// from a test.
///
/// Writes need the access code of a Samsung partnership in developer mode;
/// without it they fail with `NotAuthorized`, which is reported, not failed.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final catalog = Catalog();

  // Samsung Health shows its permission screen even when everything is granted
  const presentsScreen = {'requestPermissions'};

  for (final section in catalog.sections) {
    for (final row in section.rows) {
      test(
        '${section.title} / ${row.title}',
        skip: presentsScreen.contains(row.title),
        () async {
          if (row.isLive) {
            final updates = <String>[];
            final subscription = row.listen!(updates.add);
            await Future<void>.delayed(const Duration(seconds: 4));
            await subscription.cancel();
            // ignore: avoid_print
            print(
              'LIVE ${row.title}: ${updates.length} updates, '
              'last: ${updates.lastOrNull}',
            );
            return;
          }
          try {
            final result = await row.run!().timeout(
              const Duration(seconds: 90),
            );
            // ignore: avoid_print
            print('OK ${row.title}: $result');
          } on PlatformException catch (error) {
            // ignore: avoid_print
            print(
              'ERR ${row.title}: ${error.code}: ${error.message} '
              '(${error.details})',
            );
            if (error.details != 'NotAuthorized') rethrow;
          }
        },
        timeout: const Timeout(Duration(minutes: 3)),
      );
    }
  }
}
