import 'fixture.dart';

final simpleShader = Fixture(
  '''
void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'simple',
);

final withPrecisionShader = Fixture(
  '''
precision highp float

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'with_precision',
);

final withUniformsShader = Fixture(
  '''
uniform vec4 color;
uniform float mix_value;

void fragment(sample2D TEXTURE, vec2 UV) {
    vec4 pixelColor = texture(TEXTURE, UV);
    COLOR = mix(pixelColor, color, mix_value);
}''',
  'with_uniforms',
);

final withVersionShader = Fixture(
  '''
#version 300 es

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''',
  'with_version',
);
