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
    final convertedParameters = <_ConvertedParameter>[];
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
          if (uniform.hint != null) {
            final hint = uniform.hint!;
            switch (hint.key) {
              case 'color':
                convertedParameters.add(
                  _ConvertedParameter(
                    name: uniform.name,
                    type: 'Vector4',
                    arguments: const [
                      _Argument('red / 255'),
                      _Argument('green / 255'),
                      _Argument('blue / 255'),
                      _Argument('alpha / 255'),
                    ],
                  ),
                );
                break;
            }
          }
          parameters.add({'type': 'Color', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': '.x'});
          arguments.add({'name': uniform.name, 'extension': '.y'});
          arguments.add({'name': uniform.name, 'extension': '.z'});
          arguments.add({'name': uniform.name, 'extension': '.w'});
          break;
        case UniformType.sampler2D:
          parameters.add({'type': 'Image', 'name': uniform.name});
          samplers.add({'name': uniform.name});
          break;
        case UniformType.mat4:
          parameters.add({'type': 'Matrix4', 'name': uniform.name});
          arguments.add({'name': uniform.name, 'extension': '.storage[0]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[1]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[2]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[3]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[4]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[5]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[6]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[7]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[8]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[9]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[10]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[11]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[12]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[13]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[14]'});
          arguments.add({'name': uniform.name, 'extension': '.storage[15]'});
          break;
      }
    }

    final vars = <String, dynamic>{
      'name': specification.name,
      'parameters': parameters,
      'convertedParameters': convertedParameters.map((e) => e.toMap()).toList(),
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

class _ConvertedParameter {
  const _ConvertedParameter({
    required this.name,
    required this.type,
    String? constructor,
    required this.arguments,
  }) : constructor = constructor ?? type;

  final String name;

  final String type;

  final String constructor;

  final List<_Argument> arguments;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'constructor': constructor,
      'arguments': arguments.map((a) => a.toMap()).toList(),
    };
  }
}

class _Argument {
  const _Argument(
    this.value, {
    this.namedArgument,
  });

  final String value;

  final String? namedArgument;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'namedArgument': namedArgument,
      'hasNamedArgument': namedArgument != null,
    };
  }
}
