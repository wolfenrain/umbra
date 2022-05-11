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
uniform vec2 position;
uniform vec3 coordinates;
uniform vec4 color;
uniform float mix_value;
uniform sampler2D image;

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
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
