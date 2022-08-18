shader_type canvas_item;

uniform float strength = 0.001;

const float PI = 3.14159265359;

mat2 rotate2d(float phi){
    return mat2(vec2(cos(phi),-sin(phi)),
                vec2(sin(phi),cos(phi)));
}

void vertex() {
	vec2 pos = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xy;
	float phi = pos.x * pos.y * strength;
	VERTEX *= rotate2d(phi);
}