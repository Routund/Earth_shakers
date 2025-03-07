shader_type canvas_item;

uniform sampler2D health_meter;
uniform float level;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 text = texture(health_meter,fract(vec2(UV.x,UV.y + TIME/3.0)));
	COLOR = text;
	if (1.0-UV.y - clamp(0.0,1.0-level,0.02) * sin(5.0 * UV.x + TIME*5.0)> level){
		COLOR.a = 0.0;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
