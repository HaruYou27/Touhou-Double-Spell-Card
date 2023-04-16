//#pragma disable_preprocessor
shader_type canvas_item;

uniform sampler2D reflection : filter_nearest, repeat_enable;
uniform float water_opacity : hint_range(0.0, 1.0, 0.1) = .5;
uniform vec2 water_velocity = vec2(0., .5);
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = -7.;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;
uniform sampler2D color_map : filter_nearest, repeat_enable;
uniform vec2 velocity = vec2(0, -.1);

float nah(float a)
{
  return 1.0 - a;
}
float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}
void fragment()
{
	vec2 water_uv = UV * wave_multiplyer + TIME * water_velocity;
	float noise = texture(noise_texture, water_uv).x * wave_distortion;
	noise -= (0.5 * wave_distortion);
	
	vec2 uv = UV + TIME * velocity;
	uv.x += noise;
	vec4 water_color = texture(color_map, texture(TEXTURE, uv).rg);
	
	vec2 reflection_uv = UV;
	reflection_uv.x += noise;
	vec4 reflect_color = texture(reflection, reflection_uv);
	
	float is_alpha_zero = when_eq(reflect_color.a, 0.);
	COLOR = mix(water_color, reflect_color, water_opacity) * nah(is_alpha_zero) + is_alpha_zero * water_color;
}