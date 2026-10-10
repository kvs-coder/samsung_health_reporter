import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter_example/demo/catalog.dart';

void main() {
  final rows = Catalog().sections.expand((e) => e.rows).toList();

  test('every_samsung_health_method_has_a_row', () {
    const methods = [
      'isAvailable',
      'requestPermissions',
      'grantedPermissions',
      'isAuthorized',
      'resolve',
      'localDevice',
      'devices',
      'device',
      'read',
      'readPage',
      'userProfile',
      'aggregate',
      'insert',
      'update',
      'delete',
      'deleteByUids',
      'deleteByClientDataIds',
      'changes',
      'observe',
    ];
    for (final method in methods) {
      expect(
        rows.where((row) => row.title.split(' ').first == method),
        isNotEmpty,
        reason: method,
      );
    }
  });

  test('every_row_runs_or_listens', () {
    for (final row in rows) {
      expect(row.run != null || row.listen != null, isTrue, reason: row.title);
    }
    expect(rows.where((row) => row.isLive).map((row) => row.title), [
      'observe',
    ]);
  });
}
