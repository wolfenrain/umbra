import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:umbra/src/generators/in_memory_generator_target.dart';
import 'package:umbra/src/generators/templates/flutter_widget_file_bundle.dart';
import 'package:umbra/umbra.dart';

/// {@template flutter_widget_generator}
/// Generates a Flutter Widget file from a [ShaderSpecification].
/// {@endtemplate}
class FlutterWidgetGenerator extends Generator {
  /// {@macro flutter_widget_generator}
  FlutterWidgetGenerator(
    super.specification, {
    required List<int> spirvBytes,
  }) : _spirvBytes = spirvBytes;

  final List<int> _spirvBytes;

  /// Generates the Flutter Widget file.
  @override
  Future<List<int>> generate() async {
    final generator = await MasonGenerator.fromBundle(flutterWidgetFileBundle);

    final parameters = <Map<String, String>>[];
    final arguments = <Map<String, String>>[];
    final samplers = <Map<String, String>>[];

    for (final uniform in specification.uniforms) {
      if (['resolution'].contains(uniform.name.toLowerCase())) {
        continue;
      }
      switch (uniform.type) {
        case UniformType.float:
          parameters.add({'type': 'double', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': ''});
          break;
        case UniformType.vec2:
          parameters.add({'type': 'Vector2', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': '.x'});
          arguments.add({'name': uniform.name, 'extension': '.y'});
          break;
        case UniformType.vec3:
          parameters.add({'type': 'Vector3', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': '.x'});
          arguments.add({'name': uniform.name, 'extension': '.y'});
          arguments.add({'name': uniform.name, 'extension': '.z'});
          break;
        case UniformType.vec4:
          parameters.add({'type': 'Vector4', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': '.x'});
          arguments.add({'name': uniform.name, 'extension': '.y'});
          arguments.add({'name': uniform.name, 'extension': '.z'});
          arguments.add({'name': uniform.name, 'extension': '.w'});
          break;
        case UniformType.sampler2D:
          parameters.add({'type': 'Image', 'name': uniform.name});
          samplers.add({'name': uniform.name});
          break;
      }
    }

    final vars = <String, dynamic>{
      'name': specification.name,
      'parameters': parameters,
      'hasParameters': parameters.isNotEmpty,
      'arguments': arguments,
      'hasArguments': arguments.isNotEmpty,
      'samplers': samplers,
      'hasSamplers': samplers.isNotEmpty,
      'spirvBytes': "'${base64Encode(_spirvBytes)}'",
    };

    final target = InMemoryGeneratorTarget();
    final files = await generator.generate(
      target,
      vars: vars,
    );

    return target.generatedFiles[files.first.path]!;
  }
}
