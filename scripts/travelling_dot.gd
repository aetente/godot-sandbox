extends Node3D

@export var the_dot : RigidBody3D
@export var multiply_launch = 10
@export var is_stopping = false

@onready var timer = Timer.new()
@onready var timer2 = Timer.new()

var move_vector = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
var is_launched = false

var timer_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = true
	timer.wait_time = 1
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

	
	timer2.one_shot = true
	timer2.wait_time = 3
	timer2.timeout.connect(_on_timer_timeout2)
	add_child(timer2)

	the_dot.body_entered.connect(_body_entered)

func _on_timer_timeout():
	the_dot.linear_velocity = Vector3.ZERO
	timer2.start()

func _on_timer_timeout2():
	is_launched = false
	timer_running = false

func _body_entered(body):
	# print("body entered")
	move_vector = move_vector.bounce(body.position.normalized())
	# .reflect(body.position.normalized())	
	is_launched = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if is_stopping and !timer_running:
		timer.start()
		timer_running = true

	if (!is_launched):
		the_dot.linear_velocity = move_vector * multiply_launch
		is_launched = true
	pass
