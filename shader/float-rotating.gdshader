shader_type canvas_item;

uniform float speed = 1.0;
uniform float offset_strength = 100.0;

const float PI = 3.14159265359;

mat2 rotate2d(float phi){
    return mat2(vec2(cos(phi),-sin(phi)),
                vec2(sin(phi),cos(phi)));
}

void vertex() {
	float phi = TIME * speed * PI;
	VERTEX *= rotate2d(phi);
	VERTEX.x += cos(TIME) * offset_strength;
	VERTEX.y += sin(TIME) * offset_strength;
}