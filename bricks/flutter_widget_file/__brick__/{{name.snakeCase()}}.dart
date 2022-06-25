import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template {{name.snakeCase()}}}
/// A Flutter Widget for the `{{name}}` shader.
/// {@endtemplate}
class {{name.pascalCase()}} extends UmbraWidget {
  /// {@macro {{name.snakeCase()}}}
  const {{name.pascalCase()}}({
    super.key,
    super.blendMode = BlendMode.src,
    super.child,
    super.errorBuilder,
    super.compilingBuilder,{{#parameters}}
    required {{type}} {{name.camelCase()}},{{/parameters}}
  })  : {{#parameters}}_{{name.camelCase()}} = {{name.camelCase()}},
        {{/parameters}}super();

  static Future<FragmentProgram>? _cachedProgram;
{{#parameters}}
  final {{type}} _{{name.camelCase()}};
{{/parameters}}
  @override
  List<double> getFloatUniforms() {
    return {{#hasArguments}}{{> with_float_uniforms.dart}}{{/hasArguments}}{{^hasArguments}}{{> without_float_uniforms.dart}}{{/hasArguments}}
  }

  @override
  List<ImageShader> getSamplerUniforms() {
    return {{#hasSamplers}}{{> with_sampler_uniforms.dart}}{{/hasSamplers}}{{^hasSamplers}}{{> without_sampler_uniforms.dart}}{{/hasSamplers}}
  }

  @override
  Future<FragmentProgram> program() {
    return _cachedProgram ??
        FragmentProgram.compile(
          spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
        );
  }
}

const _spirv =
    {{{spirvBytes}}};
