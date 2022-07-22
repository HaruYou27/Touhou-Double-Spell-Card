shader_type canvas_item;
render_mode blend_mix;

uniform lowp float speed = 1.0;
uniform lowp float offset_strength = 100.0;

const lowp float PI = 3.14159265359;

mat2 rotate2d(lowp float phi){
    return mat2(vec2(cos(phi),-sin(phi)),
                vec2(sin(phi),cos(phi)));
}

void vertex() {
	lowp float phi = TIME * speed * PI;
	VERTEX *= rotate2d(phi);
	VERTEX.x += cos(TIME) * offset_strength;
	VERTEX.y += sin(TIME) * offset_strength;
}