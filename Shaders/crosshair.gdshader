shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D cross_hair_image;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE,SCREEN_UV);
	vec4 crosshair = texture(cross_hair_image,UV);
	vec4 invert = vec4(1.0-color.r,1.0-color.g,0.25-color.b,crosshair.a);
	COLOR = invert;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
