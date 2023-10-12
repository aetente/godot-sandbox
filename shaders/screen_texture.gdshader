shader_type spatial;
uniform sampler2D screen_tex_frg_2 : hint_screen_texture;



void fragment() {
// Input:3
	vec2 n_out3p0 = vec2(SCREEN_UV.x, 1. - SCREEN_UV.y);


	vec4 n_out2p0;
// Texture2D:2
	n_out2p0 = texture(screen_tex_frg_2, n_out3p0);


// Output:0
	ALBEDO = vec3(n_out2p0.xyz);


}
