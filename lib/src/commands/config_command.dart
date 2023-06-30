import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template sample_command}
///
/// `file_organizer_cli sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class Config extends Command<int> {
  /// {@macro sample_command}
  Config({
    required Logger logger,
  }) : _logger = logger {
    argParser.addMultiOption(
      'mode',
      allowed: [
        'dry',
        'move',
        'copy',
      ],
    );
  }

  @override
  String get description => 'A sample sub command that just prints one joke';

  @override
  String get name => 'sample';

  final Logger _logger;

  @override
  Future<int> run() async {
    var output = 'Which unicorn has a cold? The Achoo-nicorn!';
    if (argResults?['cyan'] == true) {
      output = lightCyan.wrap(output)!;
    }
    _logger.info(output);
    return ExitCode.success.code;
  }
}
