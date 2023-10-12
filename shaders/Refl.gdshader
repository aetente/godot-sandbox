//https://github.com/danilw/godot-utils-and-other/blob/master/Dynamic%20sky%20and%20reflection/shaders/Refl.shader
shader_type spatial;
render_mode unshaded;
uniform sampler2D tex_panorama : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	//VERTEX = 1.*normalize(VERTEX);
    //VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    //NORMAL = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
    // same as above for binormal and tangent, if normal mapping is used
}

vec2 uv_sphere(vec3 v)
{
	float pi = 3.1415926536;
	vec2 uv=vec2(0.5 + atan(v.z, v.x) / (2.0 * pi), acos(v.y) / pi);
	uv.y=0.5-uv.y;
	uv.x=-0.75+uv.x;
	uv=fract(uv);
	return uv;
}

vec2 cubemap(in vec3 d)
{
	vec3 a = abs(d);
	bvec3 ip =greaterThan(d,vec3(0.));
	vec2 uvc;
	if (ip.x && a.x >= a.y && a.x >= a.z) {uvc.x = -d.z;uvc.y = d.y;
	return 0.5 * (uvc / a.x + 1.);
	}else
	if (!ip.x && a.x >= a.y && a.x >= a.z) {uvc.x = d.z;uvc.y = d.y;
	return 0.5 * (uvc / a.x + 1.);
	}else
	if (ip.y && a.y >= a.x && a.y >= a.z) {uvc.x = d.x;uvc.y = -d.z;
	return 0.5 * (uvc / a.y + 1.);
	}else
	if (!ip.y && a.y >= a.x && a.y >= a.z) {uvc.x = d.x;uvc.y = d.z;
	return 0.5 * (uvc / a.y + 1.);
	}else
	if (ip.z && a.z >= a.x && a.z >= a.y) {uvc.x = d.x;uvc.y = d.y;
	return 0.5 * (uvc / a.z + 1.);
	}else
	if (!ip.z && a.z >= a.x && a.z >= a.y) {uvc.x = -d.x;uvc.y = d.y;
	return 0.5 * (uvc / a.z + 1.);
	}
	return vec2(0.);
}

vec2 uv_test(vec3 d)
{
	vec3 a = abs(d);
	vec2 uvc;
	uvc.x = d.x;
	uvc.y = d.y;
	//return 0.5 * (uvc / a.x + 1.);
	return uvc;
}


void fragment() {
	vec3 selfpos=((MODEL_MATRIX*vec4(1.0)).xyz);
	vec3 cam=((INV_VIEW_MATRIX*vec4(1.0)).xyz);
	vec3 rd=normalize(((INV_VIEW_MATRIX*vec4(normalize(-VERTEX),0.0)).xyz));
	vec3 nor=normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec3 ref = reflect(rd,nor);
	
	//vec2 tuv=uv_test(selfpos);
	//vec2 tuv = cubemap(normalize(-ref)*vec3(-1.,1.,1.));
	
	vec2 tuv = (normalize(-ref)*vec3(-1.,1.,1.)).xy;
	//vec4 albedo_tex = texture(SCREEN_TEXTURE,vec2(1. - SCREEN_UV.x, 1. - SCREEN_UV.y));
	vec4 albedo_tex = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x, 1. - SCREEN_UV.y));
	ALPHA=1.;
	ALBEDO = albedo_tex.rgb;

}
