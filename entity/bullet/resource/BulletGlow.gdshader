shader_type canvas_item;
render_mode blend_add;

uniform float time_scale;
uniform bool alpha_offset;
uniform bool spin;
uniform bool sin_alpha;
uniform sampler2D color_map;
uniform bool wobble;
uniform float wobble_min = .75;

varying vec3 color;
void vertex()
{
	float time = TIME * time_scale;

	if (alpha_offset)
	{
		time *= sign(COLOR.a - .5);
		time += 100.0 * COLOR.a;
		COLOR.a = 1.0;
	}
    if (spin)
	{
    	float phi = time * PI;
        VERTEX *= mat2(vec2(cos(phi),-sin(phi)),
                       vec2(sin(phi),cos(phi)));
    }
	if (wobble)
	{
		VERTEX *= wobble_min + abs(sin(time)) * (1.0 - wobble_min);
	}
	if (sin_alpha)
	{
		COLOR.a = sin(time);
	}
	color = texture(color_map, vec2(abs(sin(time)))).rgb;
}
void fragment()
{
	//shift color through time across color map - mix it with white color.
	COLOR.rgb = mix(color, vec3(1.), COLOR.r);
}