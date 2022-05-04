const simpleShader = '''
void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''';

const withVersionShader = '''
#version 300 es

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''';

const withPrecisionShader = '''
precision highp float

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}''';

const withUniformsShader = '''
uniform vec4 color;
uniform float mix_value;

void fragment(sample2D TEXTURE, vec2 UV) {
    vec4 pixelColor = texture(TEXTURE, UV);
    COLOR = mix(pixelColor, color, mix_value);
}''';
