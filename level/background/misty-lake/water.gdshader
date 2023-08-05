shader_type canvas_item;
#pragma disable_preprocessor

group_uniforms wave;
uniform vec2 wave_velocity = vec2(0., 2.);
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = -7.;

group_uniforms water;
uniform vec2 water_velocity = vec2(0, -.2);
uniform sampler2D color_map : filter_nearest, repeat_enable;

varying vec2 wave_uv;
varying vec2 water_uv;

void vertex()
{
	wave_uv = UV * wave_multiplyer + TIME * wave_velocity;
	water_uv = TIME * water_velocity + UV;
}
void fragment()
{
	COLOR = texture(color_map, texture(TEXTURE, vec2(water_uv.x + texture(TEXTURE, wave_uv).x * wave_distortion, water_uv.y)).rg);
}