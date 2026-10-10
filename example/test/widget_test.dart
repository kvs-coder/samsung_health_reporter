import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter_example/demo/catalog.dart';

void main() {
  test('catalog_has_every_library_area', () {
    expect(Catalog().sections.map((e) => e.title), [
      'Manager',
      'Reader',
      'Aggregates',
      'Writer',
      'Observer',
    ]);
  });
}
