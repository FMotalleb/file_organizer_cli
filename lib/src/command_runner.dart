import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:file_organizer_cli/src/commands/commands.dart';
import 'package:file_organizer_cli/src/file_organizer/file_system_layer.dart';
import 'package:file_organizer_cli/src/file_organizer/formatter.dart';
import 'package:file_organizer_cli/src/file_organizer/organizer.dart';
import 'package:file_organizer_cli/src/version.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pub_updater/pub_updater.dart';

const executableName = 'file_organizer_cli';
const packageName = 'file_organizer_cli';
const description =
    'This CLI can be used to organize many files with single command.';
final _sep = Platform.pathSeparator;

/// {@template file_organizer_cli_command_runner}
/// A [CommandRunner] for the CLI.
///
/// ```
/// $ file_organizer_cli --version
/// ```
/// {@endtemplate}
class FileOrganizerCliCommandRunner extends CompletionCommandRunner<int> {
  /// {@macro file_organizer_cli_command_runner}
  FileOrganizerCliCommandRunner({
    Logger? logger,
    PubUpdater? pubUpdater,
  })  : _logger = logger ?? Logger(),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super(executableName, description) {
    // Add root options and flags
    argParser
      ..addOption(
        'matcher',
        help: '''
Regexp to select files in working directory must have groups 
e.g: "SeriesName\\$_sep.S(?<season>\\d{1,2})E(?<episode>\\d{1,2}).mkv"
''',
        mandatory: true,
      )
      ..addOption(
        'format',
        help: '''
address of each matched file
in given example of matcher:
  SeriesName${_sep}S<season>${_sep}E<episode>.mkv
this may contain absolute path:
  D:${_sep}Series${_sep}SeriesName${_sep}S<season>${_sep}E<episode>.mkv
''',
        mandatory: true,
      )
      ..addOption(
        'mode',
        help: '''
Using this option you are able to switch between three modes:
  dry(dry-run): will not do anything to files only prints out changes that will be made if you used other options
  move: move files to destination (fast, but if you are not careful you may lose your files)
  copy: only make a copy of file in the destination (slow, but most reliable) 
''',
        allowed: [
          'dry',
          'move',
          'copy',
        ],
        mandatory: true,
      )
      ..addOption(
        'working-dir',
        help: 'Sets working directory of the organizer',
        defaultsTo: Directory.current.path,
      )
      ..addSeparator('------------------------------')
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print the current version.',
      )
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Noisy logging, including all shell commands executed.',
      );
    // Add sub commands

    // addCommand(Config(logger: _logger));
    // addCommand(UpdateCommand(logger: _logger, pubUpdater: _pubUpdater));
  }

  @override
  void printUsage() => _logger.info(usage);

  final Logger _logger;
  final PubUpdater _pubUpdater;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);
      if (topLevelResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    // Verbose logs
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }

    // Run the command or show version
    var exitCode = 0;

    if (topLevelResults['version'] == true) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      try {
        final mode = switch (topLevelResults['mode']) {
          'copy' => FileRelocateMode.copy,
          'move' => FileRelocateMode.move,
          _ => FileRelocateMode.dryRun,
        };
        final workDir = topLevelResults['working-dir'].toString();
        final format = topLevelResults['format'].toString();
        final matcher = topLevelResults['matcher'].toString();
        final organizer = Organizer(
          fsLayer: FileSystemLayer(
            relocateMode: mode,
            workingDirectory: workDir,
            logger: _logger,
          ),
          formatter:
              Formatter(format: format, pattern: defaultFormatterPattern),
          selectPattern: RegExp(matcher),
        );
        await organizer.invoke();
        exitCode = 0;
      } catch (e) {
        _logger.warn(e.toString());
        exitCode = await super.runCommand(topLevelResults) ?? 1;
      }
    }

    // Check for updates
    if (topLevelResults.command?.name != UpdateCommand.commandName) {
      await _checkForUpdates();
    }

    return exitCode;
  }

  /// Checks if the current version (set by the build runner on the
  /// version.dart file) is the most recent one. If not, show a prompt to the
  /// user.
  Future<void> _checkForUpdates() async {
    try {
      final latestVersion = await _pubUpdater.getLatestVersion(packageName);
      final isUpToDate = packageVersion == latestVersion;
      if (!isUpToDate) {
        _logger
          ..info('')
          ..info(
            '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
Run ${lightCyan.wrap('$executableName update')} to update''',
          );
      }
    } catch (_) {}
  }
}
