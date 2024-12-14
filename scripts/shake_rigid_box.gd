extends RigidBody3D

var t = 0
var is_moving = false
# Called when the node enters the scene tree for the first time.
func _ready():
	OS.open_midi_inputs()
	pass # Replace with function body.

func _input(event):
	if event is InputEventMIDI:
		if (event.pitch > 100):
			if event.message == 9:
				is_moving = true
				if position.distance_to(Vector3.ZERO) < 0.3:
					linear_velocity = Vector3(0, 10, 0)
			elif event.message == 8:
				is_moving = false

	if Input.is_action_just_released("jump"):
		is_moving = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t+=0.1
	# rotate_x((sin(t)) * delta)
	# rotate_y((2 * cos(t)) * delta)
	# rotate_z((3 * sin(t)) * delta)
	# if position.distance_to(Vector3.ZERO) < 4:
	# 	var move_y = pow(sin(t)/10,2)
	# 	translate(Vector3(0, move_y, 0))
	# else:
	# print(position.distance_to(Vector3.ZERO))
	if !is_moving and position.distance_to(Vector3.ZERO) > 1.5:
		linear_velocity = position.direction_to(Vector3.ZERO)*20
	pass
