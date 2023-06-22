shader_type canvas_item;

uniform float time_scale;
uniform bool spin;
uniform bool alpha_offset;
uniform bool sin_alpha;

group_uniforms colorize;
uniform sampler2D color_map;
uniform bool rainbow;

group_uniforms wobble;
uniform bool wobble;
uniform float wobble_min = .75;

varying float time;
void vertex()
{
	time = TIME * time_scale;

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
		VERTEX *= wobble_min + abs(sin(time + 1000.0*COLOR.a)) * (1.0 - wobble_min);
	}
	if (sin_alpha)
	{
		COLOR.a = sin(time);
	}
}
void fragment()
{
	vec2 uv = COLOR.rg;
	COLOR.rgb = texture(color_map, uv).rgb;
	if (rainbow)
	{
		COLOR.rgb = mix(COLOR.rgb, texture(color_map, uv + time).rgb, uv.r);
	}
}