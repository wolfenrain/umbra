precision highp float;

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}