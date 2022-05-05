{{version}}

{{precision}};

layout (location = 0) out vec4 COLOR;

{{{uniforms}}}

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}

{{{userCode}}}