#version 320 es

precision mediump float;

layout (location = 0) out vec4 COLOR;

layout (location = 0) uniform vec4 color;
layout (location = 1) uniform float mix_value;
layout (location = 2) uniform vec2 resolution;

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}

void fragment(sample2D TEXTURE, vec2 UV) {
    vec4 pixelColor = texture(TEXTURE, UV);
    COLOR = mix(pixelColor, color, mix_value);
}