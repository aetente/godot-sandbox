extends MeshInstance3D

var material : ShaderMaterial = self.get_active_material(0);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("jump"):
		material.set_shader_parameter('is_moving', true);
	else:
		material.set_shader_parameter('is_moving', false);
