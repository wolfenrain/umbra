import 'package:mason/mason.dart';
import 'package:umbra_core/src/generators/in_memory_generator_target.dart';
import 'package:umbra_core/src/generators/shader/templates/shader_file_bundle.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template umbra_shader_generator}
/// Generates a shader from a [ShaderSpecification].
/// {@endtemplate}
class ShaderGenerator {
  /// {@macro umbra_shader_generator}
  ShaderGenerator(this.specification);

  /// The shader to generate.
  final ShaderSpecification specification;

  /// Generates the umbra shader data.
  Future<String> generate() async {
    final generator = await MasonGenerator.fromBundle(shaderFileBundle);

    final vars = <String, dynamic>{
      'name': specification.name,
      'version': specification.version,
      'precision': specification.precision,
      'uniforms': specification.uniforms
          .map(
            (e) =>
                'layout (location = ${specification.uniforms.indexOf(e)}) $e;',
          )
          .join('\n'),
      'userCode': specification.userCode.join('\n'),
    };

    final target = InMemoryGeneratorTarget();
    final files = await generator.generate(
      target,
      vars: vars,
    );

    return String.fromCharCodes(target.generatedFiles[files.first.path]!);
  }
}
