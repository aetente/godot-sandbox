extends RigidBody3D

var linear_spring_stiffness: float = 400.0
var linear_spring_damping: float = 20.0
var max_linear_force: float = 500.0

var angular_spring_stiffness: float = 100.0
var angular_spring_damping: float = 10.0
var max_angular_force: float = 200.0

var target_transform

# Called when the node enters the scene tree for the first time.
func _ready():
	target_transform = transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var rotation_difference: Basis = (target_transform.basis * transform.basis.inverse())

	var position_difference:Vector3 = target_transform.origin - transform.origin
	
	if position_difference.length_squared() > 1.0:
		transform = target_transform
	else:
		var force: Vector3 = hookes_law(position_difference, self.linear_velocity, linear_spring_stiffness, linear_spring_damping)
		force = force.limit_length(max_linear_force)
		self.linear_velocity += (force * delta)
	
	var torque = hookes_law(rotation_difference.get_euler(), self.angular_velocity, angular_spring_stiffness, angular_spring_damping)
	torque = torque.limit_length(max_angular_force)
	
	self.angular_velocity += torque * delta

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)
