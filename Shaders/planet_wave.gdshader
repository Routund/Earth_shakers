shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D impact_data;
uniform sampler2D impact_meta_data;
uniform int num_impacts;
uniform float radius;
uniform float outside_time = 0.0;

uniform float e = 2.718281;
uniform float dampening = 3.2;
uniform float phase_shift = 0.785398163;
uniform float frequency = 22.0;
uniform float height = 0.13;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_albedo2 : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
varying float additive;

void vertex() {
	int i = 0;
	additive = 0.0;
	vec3 vec_normal = normalize(VERTEX.xyz);

	while (i < num_impacts){
		vec2 coords = vec2(1.0/float(num_impacts) * (float(i) + 0.5),0);
		vec4 impact_point = texture(impact_data, coords);
		vec4 impact_meta = texture(impact_meta_data, coords);
		impact_point.xyz = (impact_point.xyz - vec3(0.5,0.5,0.5)) * 2.0;
		float angle = acos(dot(impact_point.xyz,vec_normal));
		float x = abs(0.5 + angle - (outside_time) + impact_point.a * 900.0);
		additive -= height  * impact_meta.r * pow(e,-dampening * x) * (cos(frequency * x + phase_shift) + sin(frequency*x + phase_shift));
		i+=1;
	}

	VERTEX = vec_normal * (length(VERTEX) + additive);

	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	vec4 wave_tex = texture(texture_albedo2, base_uv);
	vec3 new_tex = albedo_tex.rgb * (1.0 - additive) + wave_tex.rgb * additive * 10.0;
	ALBEDO = new_tex;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
}

//void light() {
		//// Calculate some vectors.
	//vec3 lightColor = LIGHT_COLOR / PI;
	//
	//vec3 half = normalize(VIEW + LIGHT);
	//
	//float NdotL = max(dot(NORMAL, LIGHT), 0.0);
	//float NdotV = max(dot(NORMAL, VIEW), 0.0);
	//float NdotH = max(dot(NORMAL, half), 0.0);
	//float LdotH = max(dot(LIGHT, half), 0.0);
	//
	//// Diffuse light (Lambert).
	//DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * lightColor * (1.0 + additive);
//}
