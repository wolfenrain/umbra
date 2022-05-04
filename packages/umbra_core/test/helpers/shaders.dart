import 'dart:io';

import 'package:path/path.dart' as path;

final simpleShader = ShaderFixture(
  '''
void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'simple',
);

final withPrecisionShader = ShaderFixture(
  '''
precision highp float

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'with_precision',
);

final withUniformsShader = ShaderFixture(
  '''
uniform vec4 color;
uniform float mix_value;

void fragment(sample2D TEXTURE, vec2 UV) {
    vec4 pixelColor = texture(TEXTURE, UV);
    COLOR = mix(pixelColor, color, mix_value);
}''',
  'with_uniforms',
);

final withVersionShader = ShaderFixture(
  '''
#version 300 es

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'with_version',
);

class ShaderFixture {
  ShaderFixture(String input, this._outputFile)
      : input = List.unmodifiable(input.split('\n'));

  final List<String> input;

  final String _outputFile;

  File outputFile(Directory cwd) {
    return File.fromUri(
      Uri.parse(
        path.join(
          cwd.path,
          'test',
          'fixtures',
          'shaders',
          '$_outputFile.glsl',
        ),
      ),
    );
  }
}
