class DateTimeFormatter {
  /// Parses ISO-8601 string to UTC DateTime safely.
  static DateTime? parseIsoUtc(String? dtStr) {
    if (dtStr == null || dtStr.isEmpty) return null;
    return DateTime.parse(dtStr).toUtc();
  }

  /// Formats DateTime to canonical ISO-8601 string in UTC.
  static String? toIsoUtc(DateTime? dt) {
    if (dt == null) return null;
    return dt.toUtc().toIso8601String();
  }
}
