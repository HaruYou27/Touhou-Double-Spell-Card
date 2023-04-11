shader_type canvas_item;

uniform float water_speed = 0.05;
uniform float wave_distortion = 0.2;
uniform float wave_multiplyer = 7.;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;

uniform vec2 velocity = vec2(0, -.1);

varying vec2 water_uv;
varying vec2 uv;

void vertex()
{
	uv = UV + TIME * velocity;
	water_uv = vec2(uv.x, uv.y * wave_multiplyer);
	water_uv.y *= water_speed;
}

void fragment() {
	float noise = texture(noise_texture, water_uv).x * wave_distortion;
	noise -= (0.5 * wave_distortion);
		
	// putting everything toghether 
	COLOR = texture(TEXTURE, vec2(UV.x + noise , UV.y));
}