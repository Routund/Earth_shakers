shader_type spatial;

render_mode cull_disabled, depth_prepass_alpha, unshaded;

varying float y_position;
const vec3 blueishness = vec3(0.1,0.35,0.8);

void vertex() {
	y_position = VERTEX.y/4.0 - 0.2;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALPHA = clamp(0.0,-y_position,1.0);
	ALBEDO = blueishness;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
