import 'fixture.dart';

final simpleShader = Fixture(
  '''
vec4 fragment(vec2 uv, vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}''',
  'simple',
);

final withPrecisionShader = Fixture(
  '''
precision highp float

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
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

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}''',
  'with_uniforms',
);

final withVersionShader = Fixture(
  '''
#version 300 es

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}''',
  'with_version',
);
