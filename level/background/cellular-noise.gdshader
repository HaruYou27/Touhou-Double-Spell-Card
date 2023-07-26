shader_type canvas_item;

uniform vec2 grid = vec2(9.0, 16.0);
uniform float speed = 4.5;
uniform sampler2D color_map : filter_nearest, repeat_enable;
uniform vec2 velocity = vec2(0.1, -.2);

varying vec2 uv;
varying float time;
void vertex()
{
	UV += velocity * TIME;
	uv = UV * grid;
	time = TIME * speed;
}

void fragment()
{
	vec2 index_uv = floor(uv);
	vec2 fract_uv = fract(uv);
	
	float noise = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			
			float random = fract(sin(dot(index_uv + neighbor, vec2(12.9898,78.233))) * 43758.5453123) * time;
			vec2 point = vec2( cos(random), sin(random) ) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			noise = min(noise, dist);
		}
	}
	noise = 1.0 - noise;
	COLOR = texture(color_map, vec2(noise));
}
