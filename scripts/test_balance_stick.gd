extends RigidBody3D

@export var is_global_rotation = false

@export var desired_angle: Vector3 = Vector3(0,0,0)

@export var angular_spring_stiffness: float = 100.0
@export var angular_spring_damping: float = 10.0
@export var max_angular_force: float = 9999.0

@export var angular_error_threshold: float = 0.0

@export var apply_for_position = false


@export var desired_position: Vector3 = Vector3(0,0,0)


@export var linear_spring_stiffness: float = 400.0
@export var linear_spring_damping: float = 20.0
@export var max_linear_force: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	
	if (apply_for_position):
		var position_difference:Vector3 = desired_position - transform.origin
		
		if position_difference.length_squared() > 1.0:
			transform.origin = desired_position
		else:
			var force: Vector3 = hookes_law(position_difference, self.linear_velocity, linear_spring_stiffness, linear_spring_damping)
			force = force.limit_length(max_linear_force)
			self.linear_velocity += (force * delta)
	
	var current_rotation = rotation
	if (is_global_rotation):
		current_rotation = global_transform.basis.get_euler()
	var rotation_difference: Vector3 = (desired_angle - current_rotation)
	if (abs(rotation_difference.length()) > angular_error_threshold):
		var torque = hookes_law(rotation_difference, self.angular_velocity, angular_spring_stiffness, angular_spring_damping)
		torque = torque.limit_length(max_angular_force)
		self.angular_velocity += torque * delta


func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)
