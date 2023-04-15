shader_type canvas_item;
#pragma disable_preprocessor

uniform sampler2D color_map : filter_nearest, repeat_enable;
uniform vec2 velocity = vec2(0, -.1);

void vertex()
{
	UV += TIME * velocity;
}
void fragment()
{
	COLOR = texture(color_map, COLOR.rg);
}
