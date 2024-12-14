extends CharacterBody3D

var t = 0
var is_moving = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("jump"):
		is_moving = true
		var move_to_point = Vector3(0,4,0)
		print(global_position.distance_to(move_to_point))
		if global_position.distance_to(move_to_point) <= 40:
			var direction_up = global_position.direction_to(move_to_point)
			velocity += direction_up * 200
			print("go up", velocity,direction_up,global_position.distance_to(move_to_point))
			move_and_slide()

	if Input.is_action_just_released("jump"):
		is_moving = false

	
	if !is_moving and global_position.distance_to(Vector3.ZERO) > 0.1:
		var direction_down = global_position.direction_to(Vector3.ZERO)
		velocity += direction_down * 200
		print("go down", velocity,direction_down,global_position.distance_to(Vector3.ZERO))
		move_and_slide()
	

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
	pass
