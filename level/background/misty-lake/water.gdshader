//#pragma disable_preprocessor
shader_type canvas_item;

uniform sampler2D reflection : filter_nearest;

group_uniforms wave;
uniform vec2 wave_velocity = vec2(0., 2.);
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = -7.;

group_uniforms water;
uniform vec2 water_velocity = vec2(0, -.2);
uniform float water_opacity : hint_range(0.0, 1.0, 0.1) = .5;
uniform sampler2D color_map : filter_nearest, repeat_enable;

varying vec2 wave_uv;
varying vec2 water_uv;

float when_gt(vec2 x, vec2 y) {
  return max(sign(x - y), 0.0).x;
}

void vertex()
{
	wave_uv = UV * wave_multiplyer + TIME * wave_velocity;
	water_uv = UV + TIME * water_velocity;
}
void fragment()
{
	float noise = texture(TEXTURE, wave_uv).x * wave_distortion;
	
	vec4 water_color = texture(color_map, texture(TEXTURE, vec2(water_uv.x + noise, water_uv.y)).rg);
	
	//Avoid glitch when uv is bigger than 1.0
	//Reflection texture shouldn't be reapeat.
	vec2 reflection_uv = vec2(UV.x + noise, UV.y - .1);
	vec4 reflect_color = texture(reflection, reflection_uv) * when_gt(vec2(1.0), reflection_uv);
							//Avoid water get destatured when reflection is transparent.
	COLOR = mix(water_color, reflect_color, min(water_opacity, sign(reflect_color.a)));
}