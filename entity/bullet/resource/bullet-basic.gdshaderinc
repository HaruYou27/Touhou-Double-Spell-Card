uniform float time_scale;
uniform sampler2D color_map;

varying vec3 color;
void vertex()
{
	//Offset vertex to the center of the image.
	VERTEX -= 0.5 / TEXTURE_PIXEL_SIZE;
	float theta = COLOR.g;
	VERTEX *= mat2(vec2(cos(theta),-sin(theta)),
                   vec2(sin(theta),cos(theta)));
	
	float time = TIME * time_scale;
	#ifdef OFFSET_TIME
		//Offset time by r channel.
		time *= sign(COLOR.r - .5);
		time += 100.0 * COLOR.r;
	#endif
	
	//shift color through time across color map - mix it with white color.
	color = texture(color_map, vec2(abs(sin(time)))).rgb;
	
	#ifdef BLINKING
		//Blinking effect.
		COLOR.a = sin(time);
	#endif
	
	//Block color modulate pass through fragment.
	COLOR.rgb = vec3(1.0);
}
void fragment()
{
	COLOR.rgb = mix(color, vec3(1.), COLOR.r);
}