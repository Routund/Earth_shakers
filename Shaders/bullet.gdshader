shader_type spatial;

const vec4 bullet_color = vec4(232.0/256.0,169.0/256.0,49.0/256.0,1.0);
varying float x_position;
varying float z_position;


void vertex() {
	x_position = VERTEX.x;
	z_position = VERTEX.z;
	// Called for every vertex the material is visible on.
}

void fragment() {

	ALPHA = 2.0/sqrt(pow(abs(x_position),2.0) + pow(abs(z_position),2.0));
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
