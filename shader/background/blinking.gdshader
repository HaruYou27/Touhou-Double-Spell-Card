shader_type canvas_item;
render_mode unshaded;

uniform float speed = 1.0;
uniform vec2 velocity = vec2(0, -.1);
uniform float left2right : hint_range(-1., 1.) = 0.;
uniform float up2down : hint_range(-1., 1.) = 0.;

void vertex()
{
	UV += TIME * velocity;
}
void fragment()
{
	COLOR.a *= abs(sin(TIME*speed + UV.y*up2down + UV.x*left2right));
}