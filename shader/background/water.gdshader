shader_type canvas_item;

uniform float water_speed = 0.05;
uniform float wave_distortion = 0.2;
uniform int wave_multiplyer = 7;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;

uniform vec2 velocity = vec2(0, -.1);

void vertex()
{
	UV += TIME * velocity;
}

void fragment() {
	// distorted reflections
	vec2 water_uv = vec2(UV.x, UV.y * float(wave_multiplyer));
	float noise = texture(noise_texture, vec2(water_uv.x, water_uv.y + TIME * water_speed)).x * wave_distortion;
	noise -= (0.5 * wave_distortion);
		
	// putting everything toghether 
	COLOR = texture(TEXTURE, vec2(UV.x + noise , UV.y));
}