shader_type canvas_item;

uniform sampler2D reflection : filter_nearest, repeat_disable;
uniform float water_opacity : hint_range(0.0, 1.0, 0.1) = .5;
uniform float water_speed = 0.05;
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = 7.;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;
uniform vec2 velocity = vec2(0, -.1);

varying vec2 water_uv;
varying vec2 uv;

float nah(float a)
{
  return 1.0 - a;
}
float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}
void vertex()
{
	uv = UV + TIME * velocity;
	water_uv = vec2(uv.x, uv.y * wave_multiplyer);
	water_uv.y *= water_speed;
}
void fragment() {
	float noise = texture(noise_texture, water_uv).x * wave_distortion;
	noise -= (0.5 * wave_distortion);
	uv.x += noise;
	
	vec4 reflect_color = texture(reflection, UV);
	vec4 water_color = texture(TEXTURE, uv);
	float is_alpha_zero = when_eq(reflect_color.a, 0.);
	COLOR = mix(water_color, reflect_color, water_opacity) * nah(is_alpha_zero) + is_alpha_zero * water_color;
}