shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D gradient: source_color;
uniform float fog_intensity:  hint_range(0.0, 1.0);
uniform float fog_amount: hint_range(0.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;

varying mat4 CAMERA;

void vertex() {
	//POSITION = vec4(VERTEX,	1.0);
	CAMERA = INV_VIEW_MATRIX;
}

void fragment() {
	vec4 original = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	
	vec4 view = INV_PROJECTION_MATRIX* vec4(ndc, 1.0);
	view.xyz /= view.w;
	
	vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	float linear_depth = -view.z + VERTEX.z;
	
	float fog = linear_depth * fog_amount;
	
	vec4 fog_color = texture(gradient, vec2(fog, 0.0));
	if (linear_depth > 1.0)
		ALBEDO =  mix(original.rgb, fog_color.rgb, fog_color.a * fog_intensity);
	else
		ALBEDO = fog_color.rgb;
		
	//ALBEDO = vec3(1.);
}
