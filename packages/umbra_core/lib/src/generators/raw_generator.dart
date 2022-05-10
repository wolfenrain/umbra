import 'package:mason/mason.dart';
import 'package:umbra_core/src/generators/in_memory_generator_target.dart';
import 'package:umbra_core/src/generators/templates/raw_file_bundle.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template raw_generator}
/// Generates a raw GLSL shader from a [ShaderSpecification].
/// {@endtemplate}
class RawGenerator extends Generator {
  /// {@macro raw_generator}
  RawGenerator(ShaderSpecification specification) : super(specification);

  /// Generates the raw GLSL shader.
  @override
  Future<List<int>> generate() async {
    final generator = await MasonGenerator.fromBundle(rawFileBundle);

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

    return target.generatedFiles[files.first.path]!;
  }
}
