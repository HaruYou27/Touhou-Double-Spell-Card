shader_type canvas_item;

uniform float fade_rate = 1;

varying float posY;

void vertex() {
	posY = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).y;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.a -= posY * fade_rate / 100.0;
	COLOR = color;
}