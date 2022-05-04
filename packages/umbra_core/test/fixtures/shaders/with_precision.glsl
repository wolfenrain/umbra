#version 320 es

precision highp float;

layout (location = 0) out vec4 COLOR;

layout (location = 0) uniform vec2 resolution;

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}

void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}