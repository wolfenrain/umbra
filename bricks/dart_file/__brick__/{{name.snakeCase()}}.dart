import 'dart:typed_data';
import 'dart:ui';

const _binary = <int>[];

class ShaderName {
  ShaderName._(
    this._program, {
    required Image texture,
    required Color color,
    required double time,
  }) {
    _update(texture: texture, color: color, time: time);
  }

  static Future<ShaderName> compile(
    Image texture, {
    required Color color,
    required double time,
  }) async {
    final program = await FragmentProgram.compile(
      spirv: ByteData.sublistView(
        Uint8List.fromList(
          _binary,
        ),
      ).buffer,
    );

    return ShaderName._(program, texture: texture, color: color, time: time);
  }

  final FragmentProgram _program;

  late Shader _shader;

  Shader get shader => _shader;

  void _update({
    required Image texture,
    required Color color,
    required double time,
  }) {
    _shader = _program.shader(
      floatUniforms: Float32List.fromList(
        <double>[
          color.red / 255,
          color.green / 255,
          color.blue / 255,
          color.alpha / 255,
          time,
          // Resolution
          texture.width.toDouble(),
          texture.height.toDouble(),
        ],
      ),
      samplerUniforms: <ImageShader>[
        ImageShader(
          texture,
          TileMode.clamp,
          TileMode.clamp,
          Float64List.fromList([
            1.0, 0.0, 0.0, 0.0, //
            0.0, 1.0, 0.0, 0.0, //
            0.0, 0.0, 1.0, 0.0, //
            0.0, 0.0, 0.0, 1.0, //
          ]),
        ),
      ],
    );
  }
}

void main() {
  final shader = ShaderName.compile(
    texture, // Always required
    color: const Color.fromARGB(255, 255, 255, 255), // user defined uniform
    time: 0.5, // user defined uniform
  );

  canvas.drawRect(aRect, Paint()..shader = shader.shader);
}
