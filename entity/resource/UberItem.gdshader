shader_type canvas_item;
#pragma disable_preprocessor

uniform float time_scale;
uniform bool blinking;
uniform sampler2D color_map;

varying vec2 uv;
void vertex()
{
	//Offset vertex to the center of the image.
	VERTEX -= 0.5 / TEXTURE_PIXEL_SIZE;
	
	float time = TIME * time_scale;
	//Offset time by r channel.
	time *= sign(COLOR.r - .5);
	time += 100.0 * COLOR.r;
		
	//shift color through time across color map - mix it with white color.
	uv = vec2(abs(sin(time)));
	
	float theta = COLOR.g;
	VERTEX *= mat2(vec2(cos(theta),-sin(theta)),
                   vec2(sin(theta),cos(theta)));
	
	if (blinking)
	{
		//Blinking effect.
		COLOR.a = sin(time);
	}
	//Block color modulate pass through fragment.
	COLOR.rgb = vec3(1.0);
}
void fragment()
{
	COLOR.rgb = mix(texture(color_map, uv).rgb, vec3(1.), COLOR.r);
}