import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/commands/generate/commands/commands.dart';
import 'package:umbra_cli/src/commands/generate/commands/spirv.dart';
import 'package:umbra_cli/src/umbra_command.dart';

/// {@template generate_command}
/// `umbra generate` command which holds different generation sub commands.
/// {@endtemplate}
class GenerateCommand extends UmbraCommand {
  /// {@macro generate_command}
  GenerateCommand({
    Logger? logger,
    Cmd? cmd,
  }) : super(logger: logger) {
    addSubcommand(RawCommand(logger: logger));
    addSubcommand(DartCommand(logger: logger, cmd: cmd));
    addSubcommand(SpirvCommand(logger: logger, cmd: cmd));
  }

  @override
  String get description => 'Generate different file types for a shader file.';

  @override
  String get name => 'generate';
}
