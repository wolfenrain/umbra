#version 300 es

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return texture(TEXTURE, uv);
}