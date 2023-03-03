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
	vec2 view_position = (MODEL_MATRIX * (EXTRA_MATRIX * vec4(VERTEX, 0.0, 1.0))).xy;
	alpha = when_lt(sin(TIME * speed + view_position.x * view_position.y), show_range);
}

void fragment()
{
	COLOR = texture(TEXTURE, UV) * MODULATE * alpha;
}