shader_type canvas_item;
render_mode blend_add;

uniform vec2 velocity = vec2(0.0, -0.1);
uniform float speed = 1.0;
uniform vec2 col_row = vec2(9.0, 16.0);
uniform sampler2D color_map : filter_nearest, repeat_enable;

void vertex()
{
	UV += TIME * velocity;
}
void fragment()
{
	vec2 grid = UV * col_row;
	vec2 index_uv = floor(grid);
	vec2 fract_uv = fract(grid);
	
	float noise = 1.0;  
	
	for (int y= -1; y <= 1; y++)
	{
		for (int x= -1; x <= 1; x++)
		{
			vec2 neighbor = vec2(float(x),float(y));
			//Random point.
			float time = fract(sin(dot((index_uv + neighbor).xy, vec2(12.9898,78.233))) * 43758.5453123) * TIME * speed;
			vec2 point = vec2(cos(time), sin(time)) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			noise = min(noise, dist);
		}
	}
	COLOR = texture(color_map, vec2(1.0 - noise));
}
