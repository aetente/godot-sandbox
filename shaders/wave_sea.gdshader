shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo;
uniform sampler2D texture_albedo2;
uniform sampler2D texture_vertex;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	vec2 newuv = UV;
	newuv.x /= 100.;
	newuv.y /= 100.;
    newuv.x += TIME / 200.0;
    newuv.y += TIME / 100.0;
	vec4 albedo_tex = texture(texture_vertex,newuv);
	UV=UV*uv1_scale.xy+uv1_offset.xy - TIME / 30.0;
	VERTEX.y = VERTEX.y + sin(albedo_tex.r / 1.) * 1.1 * ((VERTEX.x - 1.1) * (VERTEX.x - 1.1));
	if (VERTEX.y > 1.9)
		VERTEX.y = 1.9;
	//if (VERTEX.y > 0.65)
	//	VERTEX.y = 0.55;
	VERTEX.y -= 0.1;
}




void fragment() {
	vec2 base_uv = UV;
	vec2 base_uv2 = UV;
	base_uv2.x += TIME / 5.;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 albedo_tex2 = texture(texture_albedo2,base_uv2);
	
	vec4 wrld_vertex = INV_VIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
	float world_y = wrld_vertex.x + sin(albedo_tex.r / 1.) * 1.1 * ((wrld_vertex.x - 1.1) * (wrld_vertex.x - 1.1));
	
	float one_white = 0.0;
	if (world_y > 60.9)
	 one_white = 1.0;
	vec3 whites = vec3(one_white, one_white, one_white);
	
	ALBEDO = albedo.rgb + whites + albedo_tex2.rgb / 3.0 + albedo_tex.rgb / 2.0;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = 1.;
}
