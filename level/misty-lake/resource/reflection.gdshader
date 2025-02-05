shader_type canvas_item;

group_uniforms reflection;
uniform float water_opacity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D screen : hint_screen_texture;

group_uniforms refraction;
// Should be a noise texture.
uniform sampler2D refraction_map;
uniform float refraction_strength = 0.02;
uniform float speed = 0.1;

float when_neq(vec3 x, vec3 y)
{
  return step(distance(x, y), 0.1);
}

varying float time;
void vertex()
{
	time = TIME * speed;
}

void fragment()
{
	vec2 uv = vec2(UV.x + 0.02, UV.y + 0.02);
	vec2 refraction_offset = texture(
		refraction_map,
		vec2(
			mod(uv.x + time, 1.0),
			mod(uv.y + time, 1.0))).xy;
	// Set values between -0.5 and 0.5 (instead of 0 and 1). Otherwise the reflection will move whith increased refraction_strength

	vec2 screen_uv = uv - refraction_offset * refraction_strength;
	vec3 reflect_color = texture(screen, screen_uv).rgb;
	vec3 background_color = COLOR.rgb;
	//Reflect color must be color from foreground and vice versa.
	COLOR.rgb = mix(reflect_color, background_color, water_opacity);

	//Avoid draw on foreground object or fetch color out of uv bound.
	//reflect_color ~= color from FOREGROUNG AND background_color ~= current pixel color AND 0 >= uv <= 1
	COLOR.a = (1.0 - when_neq(reflect_color, texture(TEXTURE, screen_uv).rgb)) * when_neq(background_color, texture(screen, UV).rgb) * step(0.0, screen_uv.x) * step(0.0, screen_uv.y);
}