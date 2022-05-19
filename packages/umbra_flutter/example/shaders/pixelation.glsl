uniform float pixelSize;
uniform sampler2D image;

vec4 pixel(vec2 pos, vec2 res) {
    pos = floor(pos * res) / res;
    if (max(abs(pos.x - 0.5), abs(pos.y - 0.5)) > 0.5) {
        return vec4(0.0);
    }
    return texture(image, pos.xy).rgba;
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    return pixel(uv, resolution.xy / pixelSize);
}
