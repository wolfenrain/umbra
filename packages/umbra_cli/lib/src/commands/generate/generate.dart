import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/commands/generate/raw/raw.dart';

/// {@template generate_command}
/// Generate command for wrapping all the different type of generation commands.
/// {@endtemplate}
class GenerateCommand extends Command<int> {
  /// {@macro generate_command}
  GenerateCommand({
    Logger? logger,
  }) : _logger = logger ?? Logger() {
    addSubcommand(RawCommand(logger: _logger));
  }

  final Logger _logger;

  @override
  String get description =>
      'Generate a different type of files based on a given shader file';

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => 'generate';
}
