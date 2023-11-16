extends RigidBody3D

@export var desired_angle: Vector3 = Vector3(0,0,0)

@export var angular_spring_stiffness: float = 100.0
@export var angular_spring_damping: float = 10.0
@export var max_angular_force: float = 9999.0

@export var is_experimental_hookes_law = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var rotation_difference: Vector3 = (desired_angle - rotation)
	var torque = hookes_law(rotation_difference, self.angular_velocity, angular_spring_stiffness, angular_spring_damping)
	torque = torque.limit_length(max_angular_force)
	self.angular_velocity += torque * delta


func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, damping: float) -> Vector3:
	return (stiffness * displacement) - (damping * current_velocity)
