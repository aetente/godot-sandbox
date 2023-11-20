extends Camera3D

@export var target : Node
@export var speed : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#global_transform.origin = lerp(global_transform.origin, target.global_transform.origin, delta*speed)
	self.look_at(target.get_node('rigids/torsoEnd/torso').global_transform.origin + Vector3(0,0,0))
	#var current_rotation = Quaternion(global_transform.basis)
	#var next_rotation = current_rotation.slerp(Quaternion(target.global_transform.basis), delta*speed)
	#global_transform.basis = Basis(next_rotation)
