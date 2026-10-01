/// Safe coercions for values coming back from PostgREST.
///
/// Postgres `numeric` / `int4` / `int8` columns arrive as `int` or `double`
/// depending on the stored scale, so a plain `json['col']` cast throws a
/// `TypeError` the moment one row has a different shape than another.
library;

String? asStringOrNull(dynamic v) {
  if (v == null) return null;
  if (v is String) return v.isEmpty ? null : v;
  return v.toString();
}

String asString(dynamic v, [String fallback = '']) {
  final parsed = asStringOrNull(v);
  return parsed ?? fallback;
}

double? asDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.trim());
  return null;
}

double asDouble(dynamic v, [double fallback = 0]) {
  return asDoubleOrNull(v) ?? fallback;
}

int? asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v.trim());
  return null;
}

int asInt(dynamic v, [int fallback = 0]) {
  return asIntOrNull(v) ?? fallback;
}

bool asBool(dynamic v, {bool fallback = false}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final normalized = v.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1' || normalized == 't') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'f') {
      return false;
    }
  }
  return fallback;
}

DateTime? asDateTimeOrNull(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

DateTime asDateTime(dynamic v, {DateTime? fallback}) {
  return asDateTimeOrNull(v) ?? fallback ?? DateTime.now();
}

List<int> asIntList(dynamic v) {
  if (v is! List) return const [];
  return v.map(asIntOrNull).whereType<int>().toList();
}

Map<String, Map<String, dynamic>> asNestedDayMap(dynamic v) {
  if (v is! Map) return const {};
  final result = <String, Map<String, dynamic>>{};
  v.forEach((key, value) {
    if (value is Map) {
      result[key.toString()] = Map<String, dynamic>.from(value);
    }
  });
  return result;
}
