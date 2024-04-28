shader_type spatial;


uniform sampler2D texture_albedo : source_color;
uniform sampler2D texture_depth : hint_depth_texture;
uniform vec3 fog_color : source_color; // Color of the fog
uniform float fog_start; // Distance from camera where fog starts
uniform float fog_end;

varying float fog_factor_cache;
varying float depth;

void vertex() {
	// Called for every vertex the material is visible on.
    // float depth = length(VERTEX); 
		
	depth = texture(texture_depth, UV).r; 
    fog_factor_cache = clamp((depth - fog_start) / (fog_end - fog_start), 0.0, 1.0);

}

void fragment() {
    // Get fog factor from vertex shader
    float fog_factor = fog_factor_cache;
    
    // Mix color with fog color based on fog factor 
    ALBEDO = mix(ALBEDO, fog_color.rgb, fog_factor); 
	ALPHA = depth;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
