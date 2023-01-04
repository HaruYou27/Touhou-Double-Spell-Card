shader_type canvas_item;
render_mode unshaded;

uniform float show_range : hint_range(-1, 1) = .7;
uniform float speed = 1.0 ;

varying float alpha;

float when_lt(float x, float y)
{
  return max(sign(y - x), 0.0);
}

void vertex()
{
	alpha = when_lt(sin(TIME * speed), show_range);
}

void fragment()
{
	COLOR = texture(TEXTURE, UV) * MODULATE * alpha;
}