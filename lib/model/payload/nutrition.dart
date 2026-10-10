import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/meal_type.dart';
import 'sample.dart';

/// Equivalent of [Nutrition]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// One food intake.
///
/// Supports [map] representation.
///
/// Has a [Nutrition.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.nutrition] permissions provided.
///
class Nutrition extends WritableSample<NutritionHarmonized> {
  const Nutrition({
    required super.startTimestamp,
    this.endTimestamp,
    required super.harmonized,
    super.uid,
    super.clientDataId,
    super.zoneOffsetSeconds,
    super.dataSource,
  });

  /// End time, epoch milliseconds; null for an instantaneous measurement
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.nutrition;

  /// General constructor from JSON payload
  ///
  Nutrition.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            NutritionHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Nutrition> collect(List<dynamic> list) =>
      parseObjects(list, Nutrition.fromJson);
}

/// Equivalent of [Nutrition.Harmonized]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The values of Nutrition.
///
/// Supports [map] representation.
///
/// Has a [NutritionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class NutritionHarmonized with Payload {
  const NutritionHarmonized({
    required this.title,
    required this.mealType,
    required this.calories,
    this.carbohydrate,
    this.protein,
    this.totalFat,
    this.saturatedFat,
    this.monounsaturatedFat,
    this.polyunsaturatedFat,
    this.transFat,
    this.sugar,
    this.dietaryFiber,
    this.cholesterol,
    this.sodium,
    this.potassium,
    this.calcium,
    this.iron,
    this.vitaminA,
    this.vitaminC,
  });

  /// The food's name
  final String title;

  /// The meal the food belongs to
  final MealType mealType;

  /// Calories in kilocalories (0–99999)
  final double calories;

  /// Carbohydrate in grams
  final double? carbohydrate;

  /// Protein in grams
  final double? protein;

  /// Total fat in grams
  final double? totalFat;

  /// Saturated fat in grams
  final double? saturatedFat;

  /// Monounsaturated fat in grams
  final double? monounsaturatedFat;

  /// Polyunsaturated fat in grams
  final double? polyunsaturatedFat;

  /// Trans fat in grams
  final double? transFat;

  /// Sugar in grams
  final double? sugar;

  /// Dietary fiber in grams
  final double? dietaryFiber;

  /// Cholesterol in milligrams
  final double? cholesterol;

  /// Sodium in milligrams
  final double? sodium;

  /// Potassium in milligrams
  final double? potassium;

  /// Calcium in milligrams
  final double? calcium;

  /// Iron in milligrams
  final double? iron;

  /// Vitamin A in micrograms
  final double? vitaminA;

  /// Vitamin C in milligrams
  final double? vitaminC;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'title': title,
        'mealType': mealType.value,
        'calories': calories,
        'carbohydrate': carbohydrate,
        'protein': protein,
        'totalFat': totalFat,
        'saturatedFat': saturatedFat,
        'monounsaturatedFat': monounsaturatedFat,
        'polyunsaturatedFat': polyunsaturatedFat,
        'transFat': transFat,
        'sugar': sugar,
        'dietaryFiber': dietaryFiber,
        'cholesterol': cholesterol,
        'sodium': sodium,
        'potassium': potassium,
        'calcium': calcium,
        'iron': iron,
        'vitaminA': vitaminA,
        'vitaminC': vitaminC,
      };

  /// General constructor from JSON payload
  ///
  NutritionHarmonized.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        mealType = MealTypeFactory.from(json['mealType']),
        calories = parseDouble(json['calories']),
        carbohydrate = tryParseDouble(json['carbohydrate']),
        protein = tryParseDouble(json['protein']),
        totalFat = tryParseDouble(json['totalFat']),
        saturatedFat = tryParseDouble(json['saturatedFat']),
        monounsaturatedFat = tryParseDouble(json['monounsaturatedFat']),
        polyunsaturatedFat = tryParseDouble(json['polyunsaturatedFat']),
        transFat = tryParseDouble(json['transFat']),
        sugar = tryParseDouble(json['sugar']),
        dietaryFiber = tryParseDouble(json['dietaryFiber']),
        cholesterol = tryParseDouble(json['cholesterol']),
        sodium = tryParseDouble(json['sodium']),
        potassium = tryParseDouble(json['potassium']),
        calcium = tryParseDouble(json['calcium']),
        iron = tryParseDouble(json['iron']),
        vitaminA = tryParseDouble(json['vitaminA']),
        vitaminC = tryParseDouble(json['vitaminC']);
}
