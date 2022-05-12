import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template raw_command}
/// Generate a raw GLSL shader file based on the given shader file.
/// {@endtemplate}
class RawCommand extends BaseGenerateCommand {
  /// {@macro raw_command}
  RawCommand({super.logger, super.cmd, super.platform});

  @override
  String get description => 'Generate a raw GLSL shader file.';

  @override
  String get name => 'raw';

  @override
  String get extension => 'glsl';

  @override
  Future<List<int>> generate(ShaderSpecification specification) async {
    return RawGenerator(specification).generate();
  }
}
