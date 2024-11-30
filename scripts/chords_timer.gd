extends Node3D

@onready var timer = Timer.new()

var timer_works = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.reset_chord()
	timer.one_shot = true
	timer.wait_time = 4.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	pass # Replace with function body.

func _on_timer_timeout():
	Global.update_chord()
	timer_works = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !timer_works:
		timer_works = true
		timer.start()
	pass
