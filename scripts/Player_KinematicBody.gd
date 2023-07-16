extends CharacterBody3D

var gravity = Vector3.DOWN * 12  # strength of gravity

var speed = 4  # movement speed

var jump_speed = 6  # jump strength

var spin = 0.1  # rotation speed
@onready var cam = get_node("Camera")

#var velocity = Vector3.ZERO
var jump = false

func get_input():
	var vy = velocity.y
	velocity = Vector3()
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	if Input.is_action_pressed("move_forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("move_back"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("strafe_right"):
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("strafe_left"):
		velocity += -transform.basis.x * speed
	velocity.y = vy

func _physics_process(delta):
	velocity += gravity * delta
	get_input()
	#move_and_slide(velocity, Vector3.UP)
	move_and_slide()
	if jump and is_on_floor():
		velocity.y = jump_speed

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#if event.relative.x > 0:
		#	rotate_y(-lerp(0, spin, event.relative.x/10))
		#elif event.relative.x < 0:
	#		rotate_y(-lerp(0, spin, event.relative.x/10))
		#if event.relative.y > 0:
		#	rotate_z(-lerp(0, spin, event.relative.y/10))
		#elif event.relative.y < 0:
		#	rotate_z(-lerp(0, spin, event.relative.y/10))
		var movement = event.relative
		cam.rotation.x += -deg_to_rad(movement.y * 0.7)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y += -deg_to_rad(movement.x * 0.7)
