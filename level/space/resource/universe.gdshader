shader_type canvas_item;
uniform int iterations = 10;
uniform float formuparam = 1.00;

uniform int volsteps = 5;
uniform float stepsize = 0.347;

uniform float zoom = 1.;
uniform float tile = .5;
uniform float speed = .001;

uniform float brightness = 0.002;
uniform float distfading = 0.650;
uniform float saturation = 0.750;

varying vec3 from_const;
void vertex()
{
#if !defined(VULKAN)
	from_const = vec3(1.0,0.5-TIME*speed,0.5);
#endif
#ifdef VULKAN
	from_const = vec3(1.0, fma(TIME, -speed, 0.5), 0.5);
#endif
}

float SCurve (float value)
{
	float is_bigger = step(0.5, value);
	value -= is_bigger;
	#if !defined(VULKAN)
		value = value * value * value * value * value * 16.0 + is_bigger;
	#endif

	#ifdef VULKAN
		fma(value * value * value * value * value, 16.0, is_bigger);
	#endif
    return value;
}

void fragment()
{
	//Direction and coord.
#ifdef HIGH_PRECISION
	lowp
#endif
	vec3 dir = vec3(UV.xy*zoom*0.001,1.);
#ifdef HIGH_PRECISION
	lowp
#endif
	vec3 from = from_const;

	//volumetric rendering
#ifdef HIGH_PRECISION
	lowp
#endif
	float s = 0.1, fade=1.;
#ifdef HIGH_PRECISION
	lowp
#endif
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++)
	{
	#ifdef HIGH_PRECISION
		lowp
	#endif
		vec3 p = vec3(0.0);
	#if !defined(VULKAN)
		p = from+s*dir*0.5;
	#endif

		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		lowp float pa,a=pa=0.;

		for (int i=0; i<iterations; i++)
		{
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}

		a = pow(a, 2.3); // add contrast
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}

	v=mix(vec3(length(v)),v,saturation); //color adjust

    vec4 C = vec4(v*.01,1.);

     	C.r = pow(C.r, 0.35);
 	 	C.g = pow(C.g, 0.36);
 	 	C.b = pow(C.b, 0.38);

    vec4 L = C;

    COLOR.r = mix(L.r, SCurve(C.r), 0.7);
    COLOR.g = mix(L.g, SCurve(C.g), 1.0);
    COLOR.b = mix(L.b, SCurve(C.b), 0.2);
}