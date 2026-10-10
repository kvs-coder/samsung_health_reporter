import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/nutrition.dart';
import 'package:samsung_health_reporter/model/type/meal_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('nutrition_parses_every_field', () {
    final sut = Nutrition.fromJson(fixtures.nutrition);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, isNull);
    expect(sut.uid, 'uid-nutrition');
    final h = sut.harmonized;
    expect(h.title, 'Oatmeal');
    expect(h.mealType, MealType.breakfast);
    expect(h.calories, 350.0);
    expect(h.carbohydrate, 60.0);
    expect(h.protein, 12.0);
    expect(h.totalFat, 6.0);
    expect(h.saturatedFat, 1.0);
    expect(h.monounsaturatedFat, 2.0);
    expect(h.polyunsaturatedFat, 2.5);
    expect(h.transFat, 0.1);
    expect(h.sugar, 8.0);
    expect(h.dietaryFiber, 9.0);
    expect(h.cholesterol, 5.0);
    expect(h.sodium, 120.0);
    expect(h.potassium, 300.0);
    expect(h.calcium, 150.0);
    expect(h.iron, 3.5);
    expect(h.vitaminA, 20.0);
    expect(h.vitaminC, 1.5);
  });

  test('nutrition_round_trips', () {
    final sut = Nutrition.fromJson(fixtures.nutrition);
    expect(sut.harmonized.map['mealType'], 'BREAKFAST');
    expect(Nutrition.fromJson(sut.map), sut);
  });

  test('nutrition_minimal_json_parses', () {
    final sut = Nutrition.fromJson({
      'type': 'nutrition',
      'startTimestamp': fixtures.start,
      'harmonized': {'title': 'Apple', 'mealType': 'LUNCH', 'calories': 95},
    });
    expect(sut.harmonized.calories, 95.0);
    expect(sut.harmonized.mealType, MealType.lunch);
    expect(sut.harmonized.carbohydrate, isNull);
    expect(sut.harmonized.vitaminC, isNull);
  });
}
