import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template {{name.snakeCase()}}}
/// A Flutter Widget for the `{{name}}` shader.
/// {@endtemplate}
class {{name.pascalCase()}} extends StatelessWidget {
  /// {@macro {{name.snakeCase()}}}
  const {{name.pascalCase()}}({
    Key? key,
    BlendMode blendMode = BlendMode.src,
    Widget? child,{{#parameters}}
    required {{type}} {{name.camelCase()}},{{/parameters}}
  })  : _blendMode = blendMode,
        _child = child,{{#parameters}}
        _{{name.camelCase()}} = {{name.camelCase()}},{{/parameters}}
        super(key: key);

  static Future<FragmentProgram>? _cachedProgram;

  final BlendMode _blendMode;

  final Widget? _child;
{{#parameters}}
  final {{type}} _{{name.camelCase()}};
{{/parameters}}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _cachedProgram ??
          FragmentProgram.compile(
            spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO: Add a error builder?
          return Text('${snapshot.error}');
        }
        if (!snapshot.hasData) {
          // TODO: Add a loading builder?
          return const CircularProgressIndicator();
        }
        final program = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            return ShaderMask(
              blendMode: _blendMode,
              shaderCallback: (bounds) {
                return program.shader(
                  floatUniforms: Float32List.fromList([{{#arguments}}
                    _{{name.camelCase()}}{{extension}},{{/arguments}}
                    bounds.size.width, 
                    bounds.size.height,
                  ]),
                  {{#hasSamplers}}{{> with_sampler_uniforms.dart}}{{/hasSamplers}}{{^hasSamplers}}{{> without_sampler_uniforms.dart}}{{/hasSamplers}}
                );
              },
              child: Container(
                color: Colors.transparent,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: _child,
              ),
            );
          },
        );
      },
    );
  }
}

const _spirv =
    {{{spirvBytes}}};
