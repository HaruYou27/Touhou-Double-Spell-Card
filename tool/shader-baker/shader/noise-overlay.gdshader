shader_type canvas_item;
render_mode unshaded;

uniform vec2 velocity = vec2(0.0, -.1);

uniform sampler2D noise;
uniform sampler2D color;

void vertex()
{
	UV += TIME * velocity;
}

void fragment()
{
	COLOR = texture(color, texture(noise, UV).xy);
}