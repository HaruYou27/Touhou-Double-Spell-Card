shader_type canvas_item;
render_mode unshaded;

uniform vec2 velocity = vec2(0.0, -.1);

uniform sampler2D noise_background;
uniform sampler2D noise_nebula;
uniform sampler2D noise_stars;

void vertex()
{
	UV += TIME * velocity;
}
void fragment()
{
	vec4 bg = texture(noise_background, UV);
	vec4 nebula = texture(noise_nebula, UV);
	vec4 stars = texture(noise_stars, UV);
	
	COLOR = bg + nebula + stars;
}