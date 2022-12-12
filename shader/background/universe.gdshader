shader_type canvas_item;
render_mode unshaded;

uniform vec2 velocity = vec2(0.0, -.1);

uniform sampler2D noise_background;
uniform sampler2D color_background;

uniform sampler2D noise_nebula;
uniform sampler2D color_nebula;

uniform sampler2D noise_stars;
uniform sampler2D color_stars;

varying float time;

void vertex()
{
	UV += TIME * velocity;
}

void fragment()
{
	vec4 bg = texture(color_background, texture(noise_background, UV).xy);
	vec4 nebula = texture(color_nebula, texture(noise_nebula, UV).xy);
	vec4 stars = texture(color_stars, texture(noise_stars, UV).xy);
	
	vec4 color = bg + nebula + stars;
	COLOR = color;
}