uniform vec4 color;
uniform float mix_value;

void fragment(sample2D TEXTURE, vec2 UV) {
    vec4 pixelColor = texture(TEXTURE, UV);
    COLOR = mix(pixelColor, color, mix_value);
}