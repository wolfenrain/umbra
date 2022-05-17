#version 320 es

precision mediump float;

layout (location = 0) out vec4 _COLOR_;

layout (location = 0) uniform vec2 resolution;
layout (location = 1) uniform sampler2D TEXTURE;

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return texture(TEXTURE, uv);
}

void main()
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;

    _COLOR_ = fragment(uv, gl_FragCoord.xy);
}