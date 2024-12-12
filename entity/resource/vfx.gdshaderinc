varying float time;
uniform float time_scale;

#ifdef ZOOM
group_uniforms zoom;
uniform float scale_min;
uniform float scale_max;
#endif

void vertex()
{
	time =  TIME * time_scale;
	
#ifdef ZOOM
	VERTEX *= abs(sin(time)) * (scale_max - scale_min) + scale_min;
#endif
	
#ifdef SPIN
    float phi = time * PI;
    VERTEX *= mat2(vec2(cos(phi),-sin(phi)),
                   vec2(sin(phi),cos(phi)));
#endif
}
