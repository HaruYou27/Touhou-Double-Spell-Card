shader_type canvas_item;
render_mode blend_add;

uniform lowp float speed = 1;
uniform lowp mat4 viewport_transform;

varying lowp float hue;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void vertex() {
	lowp vec2 pos = ((WORLD_MATRIX - viewport_transform) * vec4(0.0, 0.0, 0.0, 1.0)).xy;
	hue = sin(TIME * speed * sqrt(pos.x * pos.y));
}

void fragment() {
	COLOR.rgb *= hsv2rgb(vec3(hue, 1, 1));
}