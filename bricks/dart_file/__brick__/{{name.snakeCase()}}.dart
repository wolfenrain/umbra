import 'dart:typed_data';

import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template {{name.snakeCase()}}}
/// A Dart Shader class for the `{{name}}` shader.
/// {@endtemplate}
class {{name.pascalCase()}} extends UmbraShader {
  {{name.pascalCase()}}._(
    Image texture,{{#hasParameters}} { {{#parameters}}
    required {{type}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}}{{^hasParameters}}
  {{/hasParameters}}) : super(
          _cachedProgram!,
          floatUniforms: {{#hasArguments}}[{{#arguments}}
            {{name.camelCase()}}{{extension}},{{/arguments}}
          ]{{/hasArguments}}{{^hasArguments}}[]{{/hasArguments}},
          samplers: [
            texture,{{#samplers}}
            {{name.camelCase()}}{{extension}},{{/samplers}}
          ],
        );

  /// {@macro {{name.snakeCase()}}}
  static Future<{{name.pascalCase()}}> compile(
    Image texture,{{#hasParameters}} { {{#parameters}}
    required {{type}} {{name.camelCase()}},{{/parameters}}
  }{{/hasParameters}}{{^hasParameters}}
  {{/hasParameters}}) async {
    // Caching the program on the first compile call.
    _cachedProgram ??= await FragmentProgram.compile(
      spirv: ByteData.sublistView(Uint8List.fromList(_binary)).buffer,
    );

    return {{name.pascalCase()}}._(
      texture,{{#parameters}}
      {{name.camelCase()}}: {{name.camelCase()}},{{/parameters}}
    );
  }

  static FragmentProgram? _cachedProgram;
}

const _binary = {{{spirvBytes}}};
