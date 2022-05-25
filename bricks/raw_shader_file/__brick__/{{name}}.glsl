{{version}}

{{precision}};

layout (location = 0) out vec4 _COLOR_;

{{{uniforms}}}

{{{userCode}}}

void main()
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;

    _COLOR_ = fragment(uv, gl_FragCoord.xy);
}