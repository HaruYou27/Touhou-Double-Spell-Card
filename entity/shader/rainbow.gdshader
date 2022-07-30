shader_type canvas_item;

varying lowp float h;

lowp vec3 rgb2hsv(vec3 c) {
    lowp vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    lowp vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    lowp vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    lowp float d = q.x - min(q.w, q.y);
    lowp float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

lowp vec3 hsv2rgb(vec3 c) {
    lowp vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    lowp vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

lowp float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

void vertex() {
	lowp vec2 pos = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xy;
	h = sin(pos.x * pos.y + TIME);
}

void fragment() {
	lowp vec4 color = texture(TEXTURE, UV);
	lowp vec3 colorhsv = rgb2hsv(color.rgb);
	lowp vec3 value = hsv2rgb(vec3(h, 1, 1) * colorhsv) * when_lt(colorhsv.g, 11);
	color.rgb = value;
	COLOR = color;
}