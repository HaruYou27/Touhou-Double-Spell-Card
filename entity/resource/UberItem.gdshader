shader_type canvas_item;
#pragma disable_preprocessor

uniform float time_scale;
uniform bool alpha_offset;
uniform bool spin;
uniform bool sin_alpha;
uniform sampler2D color_map;

varying vec2 uv;
void vertex()
{
	float time = TIME * time_scale;
	if (alpha_offset)
	{
		time *= sign(COLOR.a - .5);
		time += 100.0 * COLOR.a;
		COLOR.a = 1.0;
	}
	uv = vec2(abs(sin(time)));
	
    if (spin)
	{
    	float phi = time * PI;
        VERTEX *= mat2(vec2(cos(phi),-sin(phi)),
                       vec2(sin(phi),cos(phi)));
    }
	if (sin_alpha)
	{
		COLOR.a = sin(time);
	}
}
void fragment()
{
	//shift color through time across color map - mix it with white color.
	COLOR.rgb = mix(texture(color_map, uv).rgb, vec3(1.), COLOR.r);
}