shader_type canvas_item;
#pragma disable_preprocessor
render_mode blend_add;

uniform sampler2D noise_texture : filter_nearest, repeat_enable;

group_uniforms wave;
uniform vec2 wave_velocity = vec2(0.0, 1);
uniform float wave_distortion = 0.03;
uniform float wave_multiplyer = -7.0;

varying vec2 wave_uv;
varying vec4 modulate;
void vertex()
{
	wave_uv = UV * wave_multiplyer + TIME * wave_velocity;
	modulate = COLOR;
}
void fragment()
{
	float noise = texture(noise_texture, wave_uv).x * wave_distortion;
	vec2 uv = vec2(UV.x - noise, UV.y);
	COLOR = texture(TEXTURE, uv) * max(sign(uv).x, 0.0) * modulate;
}