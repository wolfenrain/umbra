import 'package:umbra_cli/src/commands/generate/commands/commands.dart';
import 'package:umbra_cli/src/commands/generate/commands/spirv.dart';
import 'package:umbra_cli/src/umbra_command.dart';

/// {@template generate_command}
/// `umbra generate` command which holds different generation sub commands.
/// {@endtemplate}
class GenerateCommand extends UmbraCommand {
  /// {@macro generate_command}
  GenerateCommand({super.logger, super.cmd, super.platform}) {
    addSubcommand(RawCommand(logger: logger, cmd: cmd, platform: platform));
    addSubcommand(DartCommand(logger: logger, cmd: cmd, platform: platform));
    addSubcommand(SpirvCommand(logger: logger, cmd: cmd, platform: platform));
  }

  @override
  String get description => 'Generate different file types for a shader file.';

  @override
  String get name => 'generate';
}
