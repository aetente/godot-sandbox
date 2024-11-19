extends Node3D

@export var the_dot : RigidBody3D
@export var multiply_launch = 10

var move_vector = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
var is_launched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	the_dot.body_entered.connect(_body_entered)

func _body_entered(body):
	# print("body entered")
	move_vector = move_vector.bounce(body.position.normalized())
	# .reflect(body.position.normalized())	
	is_launched = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_launched):
		the_dot.linear_velocity = move_vector * multiply_launch
		is_launched = true
	pass
