import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_cli/src/generators/spirv_generator.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template dart_command}
/// Generate a Dart Shader file based on the given shader file.
/// {@endtemplate}
class DartCommand extends BaseGenerateCommand {
  /// {@macro dart_command}
  DartCommand({super.logger, super.cmd, super.platform});

  @override
  String get description => 'Generate a Dart Shader file.';

  @override
  String get name => 'dart';

  @override
  String get extension => 'dart';

  @override
  Future<List<int>> generate(ShaderSpecification specification) async {
    return DartGenerator(
      specification,
      spirvBytes: await SpirvGenerator(
        specification,
        cmd: cmd,
        dataDirectory: dataDirectory,
        rawBytes: await RawGenerator(specification).generate(),
      ).generate(),
    ).generate();
  }
}

// TODO(wolfen): Add SPIRV binary to dart file
// TODO(wolfen): Add SPIRV command?
// ~/.umbra/bin/glslc --target-env=opengl -fshader-stage=fragment ./test/fixtures/raw/output.glsl -o -
