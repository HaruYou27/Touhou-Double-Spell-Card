shader_type canvas_item;
#pragma disable_preprocessor
render_mode blend_add;

uniform float time_scale = 1.0;
uniform sampler2D color_map;

varying vec3 color;
void vertex()
{
	//Offset vertex to the center of the image.
	VERTEX -= 0.5 / TEXTURE_PIXEL_SIZE;
	
	float time = TIME * time_scale;
	// Time goes backward.
	time *= sign(COLOR.r - PI);
	// Offset time by r channel.
	time += 100.0 * COLOR.r;
		
	//shift color through time across color map - mix it with white color.
	color = texture(color_map, vec2(abs(sin(time)))).rgb;
	
	float theta = COLOR.g;
	VERTEX *= mat2(vec2(cos(theta),-sin(theta)),
                   vec2(sin(theta),cos(theta)));
				
	//Block color modulate pass through fragment.
	COLOR.rgb = vec3(1.0);
}
void fragment()
{
	COLOR.rgb = mix(color, vec3(1.), COLOR.r);
}