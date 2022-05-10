import 'dart:typed_data';
import 'dart:ui';

/// {@template umbra_shader}
/// The base class for all shaders generated by Umbra.
/// {@endtemplate}
class UmbraShader {
  /// {@macro umbra_shader}
  UmbraShader(
    this._program, {
    required List<double> floatUniforms,
    required List<Image> samplers,
  })  : _floatUniforms = floatUniforms,
        _samplers = samplers.map((sampler) {
          return ImageShader(
            sampler,
            TileMode.clamp,
            TileMode.clamp,
            Float64List.fromList([
              1.0, 0.0, 0.0, 0.0, //
              0.0, 1.0, 0.0, 0.0, //
              0.0, 0.0, 1.0, 0.0, //
              0.0, 0.0, 0.0, 1.0, //
            ]),
          );
        }).toList();

  final FragmentProgram _program;

  final List<double> _floatUniforms;

  final List<ImageShader> _samplers;

  /// Returns a shader that can be used on the given [resolution].
  Shader shader(Size resolution) {
    // TODO(wolfen): caching?
    return _program.shader(
      floatUniforms: Float32List.fromList([
        ..._floatUniforms,
        resolution.width,
        resolution.height,
      ]),
      samplerUniforms: _samplers,
    );
  }
}
