//#pragma disable_preprocessor
shader_type canvas_item;

uniform sampler2D reflection : filter_nearest, repeat_enable;

group_uniforms wave;
uniform vec2 wave_velocity = vec2(0., 2.);
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = -7.;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;

group_uniforms water;
uniform vec2 water_velocity = vec2(0, -.2);
uniform float water_opacity : hint_range(0.0, 1.0, 0.1) = .5;
uniform sampler2D color_map : filter_nearest, repeat_enable;

varying vec2 wave_uv;
varying vec2 water_uv;
void vertex()
{
	wave_uv = UV * wave_multiplyer + TIME * wave_velocity;
	water_uv = UV + TIME * water_velocity;
}

void fragment()
{
	float noise = texture(noise_texture, wave_uv).x * wave_distortion;
	
	vec4 water_color = texture(color_map, texture(TEXTURE, vec2(water_uv.x + noise, water_uv.y)).rg);
	vec4 reflect_color = texture(reflection, vec2(UV.x + noise, UV.y));
	
	COLOR = mix(water_color, reflect_color, min(water_opacity, sign(reflect_color.a)));
}