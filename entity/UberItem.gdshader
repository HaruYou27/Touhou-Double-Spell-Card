shader_type canvas_item;
#pragma disable_preprocessor

uniform float time_scale;
uniform bool spin;
uniform bool disable_modulate;
uniform bool sin_alpha;
group_uniforms displace;
uniform bool displace;
uniform float displace_strength = 5.0;
group_uniforms hsv_adjust;
uniform bool recolor;
uniform float h: hint_range(0, 1) = 1.0;
uniform float s: hint_range(0, 2) = 1.0;
uniform float v: hint_range(0, 2) = 1.0;
uniform bool rainbow;
group_uniforms wobble;
uniform bool wobble;
uniform float wobble_max = 1.25;
uniform float wobble_min = .75;
vec3 rgb2hsv(vec3 c)
{
     vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
     vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
     vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
     float d = q.x - min(q.w, q.y);
     float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c)
{
     vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
     vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
float when_lt(float x, float y)
{
  return max(sign(y - x), 0.0);
}
float nah(float a)
{
  return 1.0 - a;
}
varying float rainbow_hue;
void vertex()
{
	float time = TIME * time_scale;

	if (disable_modulate)
	{
		COLOR.a = 1.0;
		time *= sign(COLOR.a - .5);
	}
	if (rainbow)
	{
    	rainbow_hue = abs(sin(time)) + COLOR.a;
	}
	else
	{
		rainbow_hue = 0.0;
	}
    if (spin)
	{
    	float phi = time * PI;
        VERTEX *= mat2(vec2(cos(phi),-sin(phi)),
                       vec2(sin(phi),cos(phi)));
    }
	if (wobble)
	{
		VERTEX *= wobble_min + abs(sin(time + 1000.0*COLOR.a)) * (wobble_max - wobble_min);
	}
	if (sin_alpha)
	{
		COLOR.a = sin(time);
	}
	if (displace)
	{
		VERTEX.x += sin(time) * displace_strength;
		VERTEX.y += cos(time) * displace_strength;
	}
}
void fragment()
{
	if (recolor)
	{
		vec3 colorhsv = rgb2hsv(COLOR.rgb);
		float is_white = when_lt(colorhsv.y, 0.11);
		colorhsv *= vec3(1, s, v);
		colorhsv.x += h + rainbow_hue;
		COLOR.rgb = COLOR.rgb * is_white + hsv2rgb(colorhsv) * nah(is_white);
	}
}