shader_type spatial;

uniform sampler2D impact_data;
uniform int num_impacts;
uniform float radius;

const float e = 2.718281;
const float dampening = 2.0;
const float phase_shift = PI/4.0;
const float frequency = 15.0;
const float height = 0.09;


void vertex() {
	int i = 0;
	float additive = 0.0;
	vec3 vec_normal = normalize(VERTEX.xyz);

	while (i < num_impacts){
		vec4 impact_point = texture(impact_data, vec2(1.0/float(num_impacts) * (float(i) + 0.5),0.0));
		impact_point.xyz = (impact_point.xyz - vec3(0.5,0.5,0.5)) * 2.0;
		float angle = acos(dot(vec_normal,impact_point.xyz));
		float x = max(0,abs(angle - TIME + impact_point.a * 1000.0));
		additive -= height * pow(e,-dampening * x) * (cos(frequency * x + phase_shift) + sin(frequency*x + phase_shift));
		i+=1;
	}

	VERTEX = vec_normal * (length(VERTEX) + additive);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
