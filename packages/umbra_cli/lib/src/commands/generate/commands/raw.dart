import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template raw_command}
/// Generate a raw GLSL shader file based on the given shader file.
/// {@endtemplate}
class RawCommand extends BaseGenerateCommand {
  /// {@macro raw_command}
  RawCommand({
    Logger? logger,
  }) : super(logger: logger, generator: RawGenerator.new);

  @override
  String get description => 'Generate a raw GLSL shader file.';

  @override
  String get name => 'raw';

  @override
  String get invocation => 'umbra generate raw <input shader file>';

  @override
  String get extension => 'glsl';
}
