shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : repeat_enable;
uniform sampler2D texture_albedo2 : repeat_enable;
uniform sampler2D texture_vertex : repeat_enable;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;



float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void vertex() {
	vec2 newuv = UV;
	newuv.x /= 100.;
	newuv.y /= 100.;
    newuv.x += TIME / 200.0;
    newuv.y += TIME / 100.0;
	vec4 albedo_tex = texture(texture_vertex,newuv);
	UV=UV*uv1_scale.xy+uv1_offset.xy - TIME / 30.0;
	//VERTEX.y = VERTEX.y + sin(albedo_tex.r / 1.) * 1.1 * ((VERTEX.x - 1.1) * (VERTEX.x - 1.1));
	//if (VERTEX.y > 0.65)
	//	VERTEX.y = 0.55;
	vec4 wrld_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec4 VERTEX_LOCAL = inverse(MODEL_MATRIX) * wrld_vertex;
	//wrld_vertex.xz = wrld_vertex.xz * rotate2d(45.0);
	VERTEX_LOCAL.x += 0.6;
	VERTEX_LOCAL.x *= 30.;
	float sin_time = (sin(TIME * 1.0) + 1.0) / 2.;
	float start_x =  smoothstep(0., 1., VERTEX.x*2. + sin_time) / 1.;
	float world_x = VERTEX_LOCAL.x + sin(albedo_tex.r / 1.) * 3.1 * sin_time * (VERTEX_LOCAL.x + 20.1);
	float random_wave = 1.0 / (world_x - 20.0) * random(vec2(world_x,  world_x));
	VERTEX.y = (start_x) * ((sin(albedo_tex.r * 20.) + 1.) * 2.2);
	
	if (random_wave < 0.) {
		//VERTEX.y = 0.;
	}
}

mat2 rotate2d(float angle_a){
	float a1 = cos(angle_a);
	float a2 = -sin(angle_a);
	float b1 = sin(angle_a);
	float b2 = cos(angle_a);
	
	return mat2(vec2(a1, a2), vec2(b1, b2));
}


void fragment() {
	
	vec4 wrld_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec4 VERTEX_LOCAL = inverse(MODEL_MATRIX) * wrld_vertex;
	vec2 base_uv = VERTEX_LOCAL.xz;
	vec2 base_uv2 = VERTEX_LOCAL.xz;
	base_uv2.x += TIME / 1.;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 albedo_tex2 = texture(texture_albedo2,base_uv2);
	//wrld_vertex.xz = wrld_vertex.xz * rotate2d(45.0);
	VERTEX_LOCAL.x += 0.6;
	VERTEX_LOCAL.x *= 80.;
	float sin_time = (sin(TIME * 1.0) + 1.2);
	float world_x = VERTEX_LOCAL.x + sin(albedo_tex.r / 1.) * 3.1 * sin_time * (VERTEX_LOCAL.x + 20.1);
	
	float random_wave = 1.0 / (world_x - 20.0) * random(vec2(world_x,  world_x));
	float one_white = 0.0;
	if (random_wave > 0.01 + 0.001 * sin(TIME * 1000.)) {
		one_white = 1.0 * sin_time;
	}
	if (random_wave < 0.) {
		ALPHA = 0.;
	}
	vec3 whites = vec3(one_white, one_white, one_white);
	
	ALBEDO = albedo.rgb + whites + albedo_tex2.rgb / 3.0 + albedo_tex.rgb / 2.0;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	//ALPHA = 1.;
}
