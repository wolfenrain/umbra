#version 300 es

precision mediump float

layout (location = 0) out vec4 COLOR;

// User defined uniforms


// Flutter shader defined uniforms
layout (location = 0) uniform vec2 resolution;

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}

// User defined code
void fragment(sample2D TEXTURE, vec2 UV) {
    COLOR = texture(TEXTURE, UV);
}