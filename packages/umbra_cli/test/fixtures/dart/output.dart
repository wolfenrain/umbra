import 'dart:typed_data';

import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template input}
/// A Dart Shader class for the `input` shader.
/// {@endtemplate}
class Input extends UmbraShader {
  Input._(
    Image texture,
  ) : super(
          _cachedProgram!,
          floatUniforms: [],
          samplers: [
            texture,
          ],
        );

  /// {@macro input}
  static Future<Input> compile(
    Image texture,
  ) async {
    // Caching the program on the first compile call.
    _cachedProgram ??= await FragmentProgram.compile(
      spirv: ByteData.sublistView(Uint8List.fromList(_binary)).buffer,
    );

    return Input._(
      texture,
    );
  }

  static FragmentProgram? _cachedProgram;
}

const _binary = <int>[];
