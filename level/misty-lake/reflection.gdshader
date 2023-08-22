shader_type canvas_item;
#pragma disable_preprocessor

group_uniforms reflection;
uniform float water_opacity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D screen : hint_screen_texture; //filler nearest bug!

float when_neq(vec3 x, vec3 y)
{
  return step(distance(x, y), 0.1);
}
void fragment()
{
	vec2 uv = vec2(UV.x - 0.02, UV.y - 0.02);
	vec3 reflect_color = texture(screen, uv).rgb;
	vec3 background_color = texture(TEXTURE, UV).rgb;
	//Reflect color must be color from foreground and vice versa.
	COLOR.rgb = mix(reflect_color, background_color, water_opacity);
	
	//Avoid draw on foreground object or fetch color out of uv bound.
	//reflect_color ~= color from FOREGROUNG AND background_color ~= current pixel color AND 0 >= uv <= 1
	COLOR.a = (1.0 - when_neq(reflect_color, texture(TEXTURE, uv).rgb)) * when_neq(background_color, texture(screen, UV).rgb) * step(0.0, uv.x) * step(0.0, uv.y);
}
