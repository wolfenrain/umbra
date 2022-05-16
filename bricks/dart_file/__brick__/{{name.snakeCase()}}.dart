import 'dart:convert';
import 'dart:typed_data';

import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template {{name.snakeCase()}}}
/// A Dart Shader class for the `{{name}}` shader.
/// {@endtemplate}
class {{name.pascalCase()}} extends UmbraShader {
  {{name.pascalCase()}}._() : super(_cachedProgram!);

  /// {@macro {{name.snakeCase()}}}
  static Future<{{name.pascalCase()}}> compile() async {
    // Caching the program on the first compile call.
    _cachedProgram ??= await FragmentProgram.compile(
      spirv: Uint8List.fromList(base64Decode(_binary)).buffer,
    );

    return {{name.pascalCase()}}._();
  }

  static FragmentProgram? _cachedProgram;

  Shader shader(
    Image texture, {
    required Size resolution,{{#parameters}}
    required {{type}} {{name.camelCase()}},{{/parameters}}
  }) {
    return program.shader(
      floatUniforms: Float32List.fromList([{{#arguments}}
        {{name.camelCase()}}{{extension}},{{/arguments}}
        resolution.width,
        resolution.height,
      ]),
      samplerUniforms: [
        ImageShader(
          texture, 
          TileMode.clamp,
          TileMode.clamp,
          UmbraShader.identity,
        ),{{#samplers}}
        ImageShader(
          {{name.camelCase()}}{{extension}},
          TileMode.clamp,
          TileMode.clamp,
          UmbraShader.identity,
        ),
        {{/samplers}}
      ],
    );
  }
}

const _binary = {{{spirvBytes}}};
