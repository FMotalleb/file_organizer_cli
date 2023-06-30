import 'package:file_organizer_cli/src/file_organizer/file_system_layer.dart';
import 'package:file_organizer_cli/src/file_organizer/formatter.dart';

class Organizer {
  Organizer({
    required this.fsLayer,
    required this.formatter,
    required this.selectPattern,
  });

  final RegExp selectPattern;

  final Formatter formatter;

  final FileSystemLayer fsLayer;
  Future<void> invoke() async {
    final matches = fsLayer.listAllMatches(selectPattern);
    await for (final match in matches) {
      final data = selectPattern.firstMatch(match)!;
      final target = formatter.apply(data.toMap());
      await fsLayer.relocate(match, target);
    }
  }
}

extension on RegExpMatch {
  Map<String, String> toMap() {
    final keys = groupNames;
    final entries = keys.map((e) => MapEntry(e, namedGroup(e)!));
    return Map.fromEntries(entries);
  }
}
