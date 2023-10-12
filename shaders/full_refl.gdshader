// https://github.com/danilw/godot-utils-and-other/blob/master/Dynamic%20sky%20and%20reflection/shaders/full_refl.shader
shader_type spatial;
render_mode unshaded;

uniform sampler2D Front : source_color;
uniform sampler2D Right : source_color;
uniform sampler2D Left : source_color;
uniform sampler2D Back : source_color;
uniform sampler2D Up : source_color;
uniform sampler2D Down : source_color;

vec4 cubemap(in vec3 d)
{
	vec3 a = abs(d);
	bvec3 ip =greaterThan(d,vec3(0.));
	vec2 uvc;
	if (ip.x && a.x >= a.y && a.x >= a.z) {uvc.x = -d.z;uvc.y = d.y;
	return texture(Front,0.5 * (uvc / a.x + 1.));
	}else
	if (!ip.x && a.x >= a.y && a.x >= a.z) {uvc.x = d.z;uvc.y = d.y;
	return texture(Back,0.5 * (uvc / a.x + 1.));
	}else
	if (ip.y && a.y >= a.x && a.y >= a.z) {uvc.x = d.x;uvc.y = -d.z;
	return texture(Up,0.5 * (uvc / a.y + 1.));
	}else
	if (!ip.y && a.y >= a.x && a.y >= a.z) {uvc.x = d.x;uvc.y = d.z;
	return texture(Down,0.5 * (uvc / a.y + 1.));
	}else
	if (ip.z && a.z >= a.x && a.z >= a.y) {uvc.x = d.x;uvc.y = d.y;
	return texture(Right,0.5 * (uvc / a.z + 1.));
	}else
	if (!ip.z && a.z >= a.x && a.z >= a.y) {uvc.x = -d.x;uvc.y = d.y;
	return texture(Left,0.5 * (uvc / a.z + 1.));
	}
	return vec4(0.);
}

void fragment(){
	vec3 selfpos=((MODEL_MATRIX*vec4(1.0)).xyz);
	vec3 cam=((INV_VIEW_MATRIX*vec4(1.0)).xyz);
	vec3 rd=normalize(((INV_VIEW_MATRIX*vec4(normalize(-VERTEX),0.0)).xyz));
	vec3 nor=normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec3 ref = reflect(rd,nor);
	
	vec4 albedo_tex=cubemap(normalize(-ref)*vec3(-1.,1.,1.));
	ALPHA=1.;
	ALBEDO = albedo_tex.rgb;
	ALBEDO*=ALBEDO;
}
