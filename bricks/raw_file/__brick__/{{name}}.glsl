{{version}}

{{precision}};

layout (location = 0) out vec4 COLOR;

{{{uniforms}}}

{{{userCode}}}

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}