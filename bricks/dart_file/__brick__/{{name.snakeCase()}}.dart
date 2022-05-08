const _binary = <int>[];

class {{name.pascalCase()}} {
  {{name.pascalCase()}}._(
    Image texture, {
    // TODO(wolfen): User parameters here.
    required Color color,
    required double time,
  }) {
    _shader = _program!.shader(
      floatUniforms: Float32List.fromList(
        <double>[
          // TODO(wolfen): user uniforms here.
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
        // TODO(wolfen): any other textures.
      ],
    );
  }

  static Future<{{name.pascalCase()}}> compile(
    Image texture, {
    // TODO(wolfen): User parameters here.
    required Color color,
    required double time,
  }) async {
    _program ??= await FragmentProgram.compile(
      spirv: ByteData.sublistView(Uint8List.fromList(_binary)).buffer,
    );

    return {{name.pascalCase()}}._(texture: texture, color: color, time: time);
  }

  static FragmentProgram? _program;

  late final Shader _shader;

  Shader get shader => _shader;
}

// void main() {
//   final shader = ShaderName.compile(
//     texture, // Always required
//     color: const Color.fromARGB(255, 255, 255, 255), // user defined uniform
//     time: 0.5, // user defined uniform
//   );

//   canvas.drawRect(aRect, Paint()..shader = shader.shader);
// }
