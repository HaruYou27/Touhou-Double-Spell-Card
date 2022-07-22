shader_type canvas_item;
render_mode blend_mix;

uniform lowp float h: hint_range(0,1) = 1;

vec3 hsv2rgb(vec3 c) {
    lowp vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    lowp vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	COLOR.rgb *= hsv2rgb(vec3(h, 1, 1));
}