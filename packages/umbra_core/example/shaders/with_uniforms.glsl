uniform vec4 color;
uniform float mix_value;

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 pixelColor = texture(TEXTURE, uv);
    return mix(pixelColor, color, mix_value);
}