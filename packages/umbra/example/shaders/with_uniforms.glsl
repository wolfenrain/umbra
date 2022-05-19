uniform vec4 color;
uniform float mix_value;
uniform sampler2D image;

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 pixelColor = texture(image, uv);
    return mix(pixelColor, color, mix_value);
}