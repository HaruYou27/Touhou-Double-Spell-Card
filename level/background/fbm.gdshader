shader_type canvas_item;

uniform int octave = 4;
uniform float amplitude = 0.5;
uniform float frequency = 1.0;
uniform vec2 stretch = vec2(9.0, 16.0);
uniform float speed = 1.0;

float random(vec2 uv)
{
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}
float noise(vec2 uv)
{
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}
float fbm(vec2 uv)
{
    float amp = amplitude;
	float freque = frequency;
	float value = 0.0;
	
    for(int i = 0; i < octave; i++) {
        value += amp * noise(freque * uv + TIME * speed);
        amp *= 0.5;
        freque *= 2.0;
    }
    return value;
}

void fragment()
{
	COLOR.rgb = vec3(fbm(UV * stretch));
}