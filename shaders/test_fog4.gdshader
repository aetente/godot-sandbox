shader_type spatial;


uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;


void vertex() {	
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

float sigmoid(float x) {
	return 1./ (1. + exp(-(x * x)));
}

float posSin(float x) {
	return (sin(x) + 1.) / 2.;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = 0.9;
	
	vec4 wrld_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	
	float x = wrld_vertex.x;
	float y = wrld_vertex.y;
	float z = wrld_vertex.z;
	
	float phase_value = 12.4;
	
	//float depth_change_r = posSin((x + y + z) / 5. + phase_value / 1.) / 2. + posSin((x + y + z) / 8. + TIME / 2.) * 5. + 1.;
	//float depth_change_g = posSin((x + y + z) / 8. + phase_value / 1.) / 2. + posSin((x + y + z) / 13. + TIME / 2.) / 5. + 1.;
	//float depth_change_b = posSin((x + y + z) / 13. + phase_value / 1.) /2. + posSin((x + y + z) / 21. + TIME / 2.) / 5. + 1.;
	//depth_change_r = max(1., depth_change_r);
	//depth_change_g = max(1., depth_change_g);
	//depth_change_b = max(1., depth_change_b);
	
	float depth_change_r = posSin((x + y + z) / 3. + TIME / 2.) / 5. + 1.;
	float depth_change_g = posSin((x + y + z) / 5. + TIME / 2.) / 5. + 1.;
	float depth_change_b = posSin((x + y + z) / 8. + TIME / 2.)/5. + 1.;
	
	vec4 depth = vec4(texture(DEPTH_TEXTURE, SCREEN_UV).r,texture(DEPTH_TEXTURE, SCREEN_UV).r,texture(DEPTH_TEXTURE, SCREEN_UV).r,texture(DEPTH_TEXTURE, SCREEN_UV).r);
	depth = vec4(depth.r * 2.0 - depth_change_r,depth.g * 2.0 - depth_change_g,depth.b * 2.0 - depth_change_b,depth.a * 2.0 - 1.);
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	// depth = PROJECTION_MATRIX[3][2] / (PROJECTION_MATRIX[2][2]/ depth + PROJECTION_MATRIX[3][2]);
	//depth *= 0.01;
	//depth += VERTEX.z;
	//depth *= 0.1;
	depth.rgb = 1./(1. + exp(-(depth.rgb)));
	depth.a = 1./(1. + exp(-(pow(depth.a - 7.2, 3.)) * sigmoid(z) / 22.));
	//depth = exp(-depth * sigmoid(z)*1.);
	
	ALBEDO = vec3(pow(depth.r, 2.),pow(depth.g, 2.),pow(depth.b,3.));
	 ALPHA = pow(depth.a,VERTEX.x + 0.8 + 5. * posSin(TIME / 2.));
	//ALPHA = depth.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
