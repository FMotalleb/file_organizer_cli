final defaultFormatterPattern = RegExp('<([^>]*)>');

class Formatter {
  Formatter({
    required this.format,
    required this.pattern,
  });
  final String format;
  final Pattern pattern;
  String apply(Map<String, String> data) {
    return format.replaceAllMapped(
      pattern,
      (match) {
        final groupKey = match.group(1);
        if (!data.containsKey(groupKey)) {
          throw FormatException(
            '''
Missing key: $groupKey
  formatter cannot match $data to $format,
''',
          );
        }
        return data[groupKey]!;
      },
    );
  }
}
