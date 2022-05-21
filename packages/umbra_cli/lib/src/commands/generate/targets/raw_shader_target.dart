import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/targets/targets.dart';

/// {@template raw_shader_target}
/// A raw GLSL shader target.
/// {@endtemplate}
class RawShaderTarget extends Target {
  /// {@macro raw_shader_target}
  RawShaderTarget()
      : super(
          name: 'raw-shader',
          extension: 'glsl',
          generator: (specification, cmd, dir) => RawGenerator(specification),
          help: 'Generate a raw GLSL shader.',
        );
}
