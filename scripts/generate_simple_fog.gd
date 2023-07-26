@tool
extends Node3D

@export var amount_of_meshes : int = 16;
@export var color : Color = Color(1,1,1,1)
@export var texture: Texture2D;
@export var uv_scale: Vector3 = Vector3(1.,1.,1.);
@export var uv_offset: Vector3 = Vector3(0.,0.,0.);

# Called when the node enters the scene tree for the first time.
func _ready():
	var sphere_scale = 1.;
	var a_tmp = color.a;
	var color_tmp = color;
	var uv_offset_tmp = uv_offset
	for i in range(amount_of_meshes):
		var mesh = MeshInstance3D.new();
		var sphere = SphereMesh.new();
		sphere.radial_segments = 8;
		sphere.rings = 8;
		
		var material = StandardMaterial3D.new();
		
		var random_color_direction = color_tmp.r + color_tmp.g + color_tmp.b + color_tmp.r * color_tmp.g * color_tmp.b
		
		var t = i / 1.;
		color_tmp.r += ( 0.078 * sin(t * 0.28 + 32. * (random_color_direction)) );
		color_tmp.g += ( 0.075 * sin(t * 0.25 + 52. * (random_color_direction)) );
		color_tmp.b += ( 0.073 * sin(t * 0.23 + 82. * (random_color_direction)) );
		#color_tmp.r = fmod(color_tmp.r, 1.);
		#color_tmp.g = fmod(color_tmp.g, 1.);
		#color_tmp.b = fmod(color_tmp.b, 1.);
		if (color_tmp.r > 1.): 
			color_tmp.r = 1.;
		if (color_tmp.g > 1.): 
			color_tmp.g = 1.;
		if (color_tmp.b > 1.): 
			color_tmp.b = 1.;
		if (color_tmp.r < 0.): 
			color_tmp.r = 0.;
		if (color_tmp.g < 0.): 
			color_tmp.g = 0.;
		if (color_tmp.b < 0.): 
			color_tmp.b = 0.;
		color_tmp.a = (pow(float(i + 1)/amount_of_meshes, 1.2)) * a_tmp;
		
		if (color_tmp.a > 1.): 
			color_tmp.a = 1.;
		if (color_tmp.a < 0.): 
			color_tmp.a = 0.;
			
		if (texture):
			material.texture_repeat = true;
			material.albedo_texture = texture;
			material.emission = color_tmp;
			material.uv1_scale = uv_scale;
			material.uv1_offset = uv_offset_tmp;
			uv_offset_tmp.x += 0.1;
			uv_offset_tmp.y += 0.001;
		
		material.albedo_color = color_tmp;
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA;
		material.cull_mode = BaseMaterial3D.CULL_FRONT;
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED;
		
		sphere.surface_set_material(0, material)
		
		mesh.scale = Vector3(sphere_scale, sphere_scale, sphere_scale);
		sphere_scale += (pow(float(i)/amount_of_meshes, 66) + 1);
		
		mesh.mesh = sphere
		
		add_child(mesh)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
