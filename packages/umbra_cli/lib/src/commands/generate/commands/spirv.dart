import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_cli/src/exit_with.dart';
import 'package:umbra_cli/src/generators/generators.dart';

/// {@template spirv_command}
/// Generate a SPIR-V binary file based on the given shader file.
/// {@endtemplate}
class SpirvCommand extends BaseGenerateCommand {
  /// {@macro spirv_command}
  SpirvCommand({super.logger, super.cmd, super.platform});

  @override
  String get description => 'Generate a SPIR-V binary file.';

  @override
  String get name => 'spirv';

  @override
  String get extension => 'spirv';

  @override
  Future<List<int>> generate(ShaderSpecification specification) async {
    final generator = SpirvGenerator(
      specification,
      dataDirectory: dataDirectory,
      cmd: cmd,
      rawBytes: await RawGenerator(specification).generate(),
    );

    try {
      return await generator.generate();
    } catch (err) {
      if (err is ProcessException) {
        throw ExitWith(ExitCode.cantCreate, err.message);
      }
      rethrow;
    }
  }
}

// TODO(wolfen): Add SPIRV binary to dart file
// ~/.umbra/bin/glslc --target-env=opengl -fshader-stage=fragment ./test/fixtures/raw/output.glsl -o -
