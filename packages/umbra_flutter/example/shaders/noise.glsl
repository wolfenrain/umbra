// Based on https://www.shadertoy.com/view/lt33zn

uniform float time;

const float Scale1 = 0.3;
const float Scale2 = 3.5;
const float Amp = 20.0;
const float FreqX = 30.0;
const float FreqY = 30.0;

const mat3 m = mat3( 
    0.00,  0.80,  0.60,
    -0.80,  0.36, -0.48,
    -0.60, -0.48,  0.64 
);

float hash(float n)
{
    return fract(sin(n) * 43758.5453);
}

float noise(in vec3 x)
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f * f * (3.0 - 2.0 * f);

    float n = p.x + p.y * 57.0 + 113.0 * p.z;

    float res = mix(mix(mix(hash(n + 0.0), hash(n + 1.0), f.x),
                        mix(hash(n + 57.0), hash(n + 58.0), f.x),f.y),
                    mix(mix(hash(n + 113.0), hash(n + 114.0), f.x),
                        mix(hash(n + 170.0), hash(n + 171.0), f.x),f.y), f.z);
    return res;
}

float fbm(vec3 p)
{
    float f;
    f  = 0.5000 * noise(p); p = m * p * 2.02;
    f += 0.2500 * noise(p); p = m * p * 2.03;
    f += 0.1250 * noise(p); p = m * p * 2.01;
    f += 0.0625 * noise(p); p = m * p * 2.05;
    f += 0.0625 / 2. * noise(p); p = m * p * 2.02;
    f += 0.0625 / 4. * noise(p);
    return f;
}


vec4 fragment(vec2 uv, vec2 fragCoord)
{
	vec3 v;
	vec3 p = Scale2 * vec3(uv, 0.) - time * (1.0, 1.0, 1.0) * 0.1;
	float x = fbm(p);
	v = (.5 + .5 * sin(x * vec3(FreqX, FreqY, 1.0) * Scale1)) / Scale1;
	v *= Amp;
	vec3 Ti = texture(TEXTURE, .02 * v.xy + fragCoord.xy / resolution.xy).rgb;

	return vec4(Ti,1.0);
}