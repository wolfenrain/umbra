import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/targets/targets.dart';
import 'package:umbra_cli/src/generators/generators.dart';

/// {@template dart_shader_target}
/// A Dart Shader target.
/// {@endtemplate}
class DartShaderTarget extends Target {
  /// {@macro dart_shader_target}
  DartShaderTarget()
      : super(
          name: 'dart-shader',
          extension: 'dart',
          generator: (specification, cmd, dir) async => DartGenerator(
            specification,
            spirvBytes: await SpirvGenerator(
              specification,
              cmd: cmd,
              dataDirectory: dir,
              rawBytes: await RawGenerator(specification).generate(),
            ).generate(),
          ),
          help: 'Generate a Dart Shader.',
        );
}
