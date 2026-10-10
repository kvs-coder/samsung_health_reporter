/// Reads a number of the JSON payload.
///
num parseNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return double.parse(value);
  throw FormatException('Expected a number, got $value');
}

/// [parseNum] for optional fields.
///
num? tryParseNum(dynamic value) => value == null ? null : parseNum(value);

/// Reads a list of JSON objects, e.g. a nested payload list.
///
List<T> parseList<T>(
    dynamic value, T Function(Map<String, dynamic> json) fromJson) {
  if (value == null) return <T>[];
  return List<dynamic>.from(value)
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList();
}
