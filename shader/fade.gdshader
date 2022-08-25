shader_type canvas_item;

uniform float fade_height;
uniform float fade_rate;

varying float posY;

void vertex() {
	posY = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).y;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.a = 255.0 - (posY - fade_height) * fade_rate;
	COLOR = color;
}