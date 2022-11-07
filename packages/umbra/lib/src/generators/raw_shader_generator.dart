import 'package:mason/mason.dart';
import 'package:umbra/src/generators/in_memory_generator_target.dart';
import 'package:umbra/src/generators/templates/raw_shader_file_bundle.dart';
import 'package:umbra/umbra.dart';

/// {@template raw_shader_generator}
/// Generates a raw GLSL shader from a [ShaderSpecification].
/// {@endtemplate}
class RawShaderGenerator extends Generator {
  /// {@macro raw_shader_generator}
  RawShaderGenerator(super.specification);

  /// Generates the raw GLSL shader.
  @override
  Future<List<int>> generate() async {
    final generator = await MasonGenerator.fromBundle(rawShaderFileBundle);

    final vars = <String, dynamic>{
      'name': specification.name,
      'version': specification.version,
      'precision': specification.precision,
      'uniforms': specification.uniforms
          .map(
            (e) =>
                '''layout (location = ${specification.uniforms.indexOf(e)}) ${e.toRaw};''',
          )
          .join('\n'),
      'userCode': specification.userCode.join('\n'),
    };

    final target = InMemoryGeneratorTarget();
    final files = await generator.generate(
      target,
      vars: vars,
    );

    return target.generatedFiles[files.first.path]!;
  }
}

extension on Uniform {
  String get toRaw {
    print('calling to raw: ${type.name}, $name');
    return 'uniform ${type.name} $name';
  }
}
