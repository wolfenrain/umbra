#version 320 es

precision mediump float;

layout (location = 0) out vec4 COLOR;

layout (location = 0) uniform vec2 resolution;
layout (location = 1) uniform sampler2D TEXTURE;

vec2 UV = vec2(0.0);

void fragment() {
    COLOR = texture(TEXTURE, UV);
}

void main()
{
    UV = gl_FragCoord.xy / resolution.xy;

    fragment();
}