shader_type canvas_item;

uniform vec2 velocity = vec2(.1, .1);

void vertex()
{
	UV += TIME * velocity;
}