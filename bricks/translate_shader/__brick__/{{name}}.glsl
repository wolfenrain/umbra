// Based on https://thebookofshaders.com/08/
uniform float time;

float box(in vec2 uv, in vec2 size) {
    size = vec2(0.5) - size * 0.5;
    vec2 new_uv = smoothstep(size, size + vec2(0.001), uv);
    new_uv *= smoothstep(size, size + vec2(0.001), vec2(1.0) - uv);
    return new_uv.x * new_uv.y;
}

float cross_pixel(in vec2 uv, float size) {
    return box(uv, vec2(size, size / 4.0)) + box(uv, vec2(size / 4.0, size));
}

vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    vec3 color = vec3(0.0);

    // To move the cross we move the space
    vec2 translate = vec2(cos(time), sin(time));
    uv += translate * 0.35;

    // // Show the coordinates of the space on the background
    // color = vec3(uv.x, uv.y, 0.0);

    // Add the shape on the foreground
    color += vec3(cross_pixel(uv, 0.25));

    return vec4(color, 1.0);
}

