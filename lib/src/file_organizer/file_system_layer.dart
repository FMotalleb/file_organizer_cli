import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart';

enum FileRelocateMode {
  move(FileSystemLayer._move),
  copy(FileSystemLayer._copy),
  dryRun(FileSystemLayer._dryRelocate),
  ;

  const FileRelocateMode(this.action);
  final Future<void> Function(String from, String to, Logger logger) action;
}

class FileSystemLayer {
  FileSystemLayer({
    required this.relocateMode,
    required this.workingDirectory,
    required this.logger,
  });

  FileRelocateMode relocateMode;
  final String workingDirectory;
  final Logger logger;
  Future<void> relocate(
    String from,
    String to,
  ) =>
      relocateMode.action(
        from,
        join(workingDirectory, to),
        logger,
      );

  Stream<String> listAllMatches(
    Pattern pattern, {
    bool isRecursive = false, // TODO: maybe implemented in future
    bool followLinks = false, // TODO: maybe implemented in future
  }) {
    return Directory(
      workingDirectory,
    )
        .list(
          recursive: isRecursive,
          followLinks: followLinks,
        )
        .map(
          (event) => event.path,
        )
        .where(
          (event) => event.contains(pattern),
        );
  }

  static Future<void> _move(String from, String to, Logger logger) async {
    logger.info('file moved: $from -> $to');
    await File(to).parent.create(recursive: true);
    await File(from).rename(to);
  }

  static Future<void> _copy(String from, String to, Logger logger) async {
    logger.info('file copied: $from -> $to');
    await File(to).parent.create(recursive: true);
    await File(from).copy(to);
  }

  static Future<void> _dryRelocate(
    String from,
    String to,
    Logger logger,
  ) async {
    logger.info('relocate: $from -> $to');
  }
}
