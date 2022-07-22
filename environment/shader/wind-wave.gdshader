// original wind shader from https://github.com/Maujoe/godot-simple-wind-shader-2d/tree/master/assets/maujoe.simple_wind_shader_2d
//
// speed - The speed of the wind movement.
// minStrength - The minimal strength of the wind movement.
// maxStrength - The maximal strength of the wind movement.
// strengthScale - Scalefactor for the wind strength.
// interval - The time between minimal and maximal strength changes.
// detail - The detail (number of waves) of the wind movement.
// heightOffset - The height where the wind begins to move. By default 0.0.

shader_type canvas_item;
render_mode blend_mix;

// Wind settings.
uniform lowp float speed = 1.0;
uniform lowp float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform lowp float maxStrength : hint_range(0.0, 1.0) = 0.01;
uniform lowp float strengthScale = 100.0;
uniform lowp float interval = 3.5;
uniform lowp float detail = 1.0;
uniform lowp float heightOffset : hint_range(0.0, 1.0);

//Require pass in every frame.
uniform lowp mat4 viewport_transform;

float getWind(vec2 uv, float time){
    lowp float diff = pow(maxStrength - minStrength, 2.0);
    lowp float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
   	lowp float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
    return wind; 
}

void vertex() {
	lowp float pos = ((WORLD_MATRIX - viewport_transform) * vec4(0.0, 0.0, 0.0, 1.0)).y;
    lowp float time = TIME * speed + pos;
    VERTEX.x += getWind(UV, time);
}