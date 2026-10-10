import 'dart:convert';

import '../../exceptions.dart';
import 'json.dart';

/// Reads a Kotlin `Int` or `Long` of the JSON payload.
///
int parseInt(dynamic value) => parseNum(value).toInt();

/// [parseInt] for optional fields.
///
int? tryParseInt(dynamic value) => value == null ? null : parseInt(value);

/// Reads a Kotlin `Float` or `Double` of the JSON payload.
///
double parseDouble(dynamic value) => parseNum(value).toDouble();

/// [parseDouble] for optional fields.
///
double? tryParseDouble(dynamic value) =>
    value == null ? null : parseDouble(value);

/// Reads a nested JSON object: a map, whatever its key type,
/// or a JSON string of one, as the channel may send either.
/// Throws an [InvalidValueException] for anything else.
///
Map<String, dynamic> parseObject(dynamic value) {
  final object = value is String ? jsonDecode(value) : value;
  if (object is Map) return Map<String, dynamic>.from(object);
  throw InvalidValueException('Expected a JSON object, got $value');
}

/// Reads a list of JSON strings, e.g. the uids of deleted data points.
///
List<String> parseStrings(dynamic value) {
  if (value == null) return <String>[];
  return List<dynamic>.from(value).map((e) => e as String).toList();
}

/// Reads a list of JSON objects with [parseObject], e.g. a nested payload list.
///
List<T> parseObjects<T>(
    dynamic value, T Function(Map<String, dynamic> json) fromJson) {
  if (value == null) return <T>[];
  return List<dynamic>.from(value)
      .map((e) => fromJson(parseObject(e)))
      .toList();
}
