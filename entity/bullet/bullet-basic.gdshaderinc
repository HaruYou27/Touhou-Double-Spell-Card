
#ifdef TIME_FLOW
uniform float time_scale = 1.0;
#endif

#ifdef COLORIZE
group_uniforms colorize;
uniform sampler2D color_map;
varying vec3 color;
#endif

void vertex()
{
#ifdef TIME_FLOW
	float time = TIME * time_scale;
#endif

#if defined(TIME_OFFSET) && defined(TIME_FLOW)
	// Offset time by r channel.
	time *= sign(COLOR.r - .5);
	time += 100.0 * COLOR.r;
#endif

	// Offset vertex to the center of the image.
	VERTEX -= 0.5 / TEXTURE_PIXEL_SIZE;
	float theta = COLOR.r;
	VERTEX *= mat2(vec2(cos(theta),-sin(theta)),
                   vec2(sin(theta),cos(theta)));

#if defined(COLOR_TIME) && defined(TIME_FLOW)
	//shift color through time across color map & mix it with white color.
	color = texture(color_map, vec2(abs(sin(time)))).rgb;
#endif

#ifdef COLOR_ROTATION
	color = texture(color_map, vec2(abs(sin(theta)))).rgb;
#endif

// Block color modulate pass through fragment.
	COLOR = vec4(1.0);

#if defined(BLINKING) && defined(TIME_FLOW)
	// Blinking effect.
	COLOR.a = abs(sin(time));
#endif

}
void fragment()
{
#ifdef COLOR_UV
	COLOR.r += UV.x * UV.y;
#endif
#ifdef COLORIZE
	// Only change color of the gray -> black pixels.
	COLOR.rgb = mix(color, vec3(1.), COLOR.r);
#endif
}