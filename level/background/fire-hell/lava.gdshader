shader_type canvas_item;
#pragma disable_preprocessor

uniform sampler2D color_map : filter_nearest, repeat_enable;
uniform vec2 velocity = vec2(0, -.1);
uniform float lava_speed = 1.;
uniform float lava_chunk = 10.;

void vertex()
{
	UV += TIME * velocity;
}
void fragment()
{
	COLOR = texture(color_map, vec2(sin(COLOR.rg * lava_chunk + TIME * lava_speed)));
}
