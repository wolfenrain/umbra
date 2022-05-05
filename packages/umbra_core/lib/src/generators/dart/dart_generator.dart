import 'package:mason/mason.dart';
import 'package:umbra_core/src/generators/dart/templates/dart_file_bundle.dart';
import 'package:umbra_core/src/generators/in_memory_generator_target.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template dart_generator}
/// Generates a Dart file from a [ShaderSpecification].
/// {@endtemplate}
class RawGenerator {
  /// {@macro dart_generator}
  RawGenerator(this.specification);

  /// The shader specification input.
  final ShaderSpecification specification;

  /// Generates the Dart file.
  Future<String> generate() async {
    final generator = await MasonGenerator.fromBundle(dartFileBundle);

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
