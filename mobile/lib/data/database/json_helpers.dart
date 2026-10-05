import 'dart:convert';

/// Helper utilities for deterministic JSON encoding and decoding in Drift local database.

String? jsonEncodeOrNull(Object? object) {
  if (object == null) return null;
  return jsonEncode(object);
}

Map<String, dynamic>? jsonDecodeMapOrNull(String? rawJson) {
  if (rawJson == null || rawJson.trim().isEmpty) return null;
  final decoded = jsonDecode(rawJson);
  if (decoded is Map<String, dynamic>) return decoded;
  if (decoded is Map) return Map<String, dynamic>.from(decoded);
  return null;
}

List<String> jsonDecodeListString(String? rawJson) {
  if (rawJson == null || rawJson.trim().isEmpty) return [];
  final decoded = jsonDecode(rawJson);
  if (decoded is List) return decoded.cast<String>();
  return [];
}
