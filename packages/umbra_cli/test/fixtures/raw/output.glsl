#version 320 es

precision mediump float;

layout (location = 0) out vec4 COLOR;

layout (location = 0) uniform vec2 resolution;
layout (location = 1) uniform sampler2D TEXTURE;

void fragment(sampler2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}