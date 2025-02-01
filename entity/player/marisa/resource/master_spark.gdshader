shader_type canvas_item;
render_mode blend_add;

uniform sampler2D color_map;
uniform float speed_color = 1.0;
uniform float alpha_delta = 0.1;
uniform float speed_alpha = 2.0;
uniform float UV_diff = 1.0;

void vertex()
{
	UV.x += TIME * speed_color;
}

void fragment()
{
	COLOR.rgb = mix(texture(color_map, vec2(abs(sin(UV.x)))).rgb, vec3(1.), COLOR.r);
	COLOR.a += alpha_delta * (sin(TIME * speed_alpha + UV.x * UV_diff));
	COLOR.a = min(COLOR.a, 0.9);
}