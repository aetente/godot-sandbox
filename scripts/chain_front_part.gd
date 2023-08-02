extends RigidBody3D


const F : float = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("KEY_A"):
		self.rotation += Vector3(-0.1,0,0);
	if Input.is_action_pressed("KEY_D"):
		self.rotation += Vector3(0.1,0,0);
	if Input.is_action_pressed("KEY_E"):
		self.rotation += Vector3(0,-0.1,0);
	if Input.is_action_pressed("KEY_Q"):
		self.rotation += Vector3(0,0.1,0);
	
	if Input.is_action_pressed("KEY_W"):
		var force_value3 = Vector3(F * 1,0,0).rotated(Vector3(0,1,0), self.rotation.y).rotated(Vector3(1,0,0), self.rotation.x).rotated(Vector3(0,0,1), self.rotation.z)
		self.apply_force(force_value3, Vector3(0,0,0))
	if Input.is_action_pressed("KEY_S"):
		var force_value4 = Vector3(-F * 1,0,0).rotated(Vector3(0,1,0), self.rotation.y).rotated(Vector3(1,0,0), self.rotation.x).rotated(Vector3(0,0,1), self.rotation.z)
		self.apply_force(force_value4, Vector3(0,0,0))
