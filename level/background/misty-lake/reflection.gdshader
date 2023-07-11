shader_type canvas_item;

group_uniforms reflection;
uniform float water_opacity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D background : filter_nearest;
uniform sampler2D screen : hint_screen_texture; //filler nearest bug!

group_uniforms wave;
uniform vec2 wave_velocity = vec2(0.0, 1);
uniform float wave_distortion = 0.1;
uniform float wave_multiplyer = -7.0;

varying vec2 wave_uv;

void vertex()
{
	wave_uv = UV * wave_multiplyer + TIME * wave_velocity;
}
float when_neq(vec3 x, vec3 y)
{
  return max(sign(0.1 - distance(x, y)), 0.0);
}
void fragment()
{
	float noise = texture(TEXTURE, wave_uv).x * wave_distortion;
	vec2 uv = vec2(UV.x - noise, UV.y - 0.1);
	vec3 reflect_color = texture(screen, uv).rgb;
	vec3 background_color = texture(background, UV).rgb;
	//Reflect color must be color from foreground and vice versa.
	COLOR.rgb = mix(reflect_color, background_color, water_opacity);
	COLOR.a = (1.0 - when_neq(reflect_color, texture(background, uv).rgb)) * when_neq(background_color, texture(screen, UV).rgb) * max(sign(uv).x, 0.0);
}
