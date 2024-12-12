shader_type canvas_item;
render_mode unshaded;

uniform float speed = 1.0;

void fragment()
{
	COLOR.a *= abs(sin(TIME*speed + UV.x));
}