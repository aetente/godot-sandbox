extends Node3D

@onready var timer = Timer.new()

@export var rigid_element : RigidBody3D
@export var midi_port_in = 1
@export var midi_port_out = 1
@export var midi_channel = 0
@export var multiply_launch = 200

# TODO: add notes to dictionary on press note and remove it after note off and play note randomnly from dictionary keys

@export var audio_velocity_threshold = 0

var is_playing = false

# var midi_in = MidiIn.new()
var midi_out = MidiOut.new()

var note_to_stop = 0;

var note_value = -1;

var move_vector = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
var is_launched = false

var notes_dictionary = {}
var initialTransform
var resetTransform = false
@export var debug = false
@export var speed = 1
var direction = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	initialTransform = rigid_element.transform
	# print("aaaaaaaaaaaaaaaaaaaaaa")
	OS.open_midi_inputs()
	
	timer.one_shot = true
	timer.wait_time = 0.3
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

	# midi_in.midi_message.connect(_on_midi_message)


	# midi_in.open_port(midi_in)
	midi_out.open_port(midi_port_out)
	rigid_element.contact_monitor = true
	rigid_element.max_contacts_reported = 1
	rigid_element.body_entered.connect(_body_entered)
	pass # Replace with function body.

func _on_timer_timeout():
	midi_out.send_message([0x80, note_to_stop, 127])

# func _on_midi_message(delta, message):
# 	print("MIDI message: ", message)

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)

func _print_midi_info(midi_event):
	if (midi_event.pitch > 100):
		# print("HIT IT")
		note_value = midi_event.pitch - 3*12
		# rigid_element.linear_velocity = Vector3(0, 10, 0)
		# print(midi_event)
		# print("Channel ", midi_event.channel)
		if midi_event.message == 9:
			notes_dictionary[note_value] = note_value
		elif midi_event.message == 8:
			notes_dictionary.erase(note_value)
		# print("Message ", midi_event.message)
		# print("Pitch ", midi_event.pitch)
		# print("Velocity ", midi_event.velocity)
		# print("Instrument ", midi_event.instrument)
		# print("Pressure ", midi_event.pressure)
		# print("Controller number: ", midi_event.controller_number)
		# print("Controller value: ", midi_event.controller_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_launched):
		# move_vector = Vector3(0,-10,0)
		# print(move_vector)
		# rigid_element.add_constant_central_force(move_vector * multiply_launch)
		is_launched = true
	rigid_element.position.distance_to(Vector3.ZERO)
	if (!resetTransform and rigid_element.position.distance_to(Vector3.ZERO) > 7):
		resetTransform = true
		
	if resetTransform:
		rigid_element.transform = initialTransform
		resetTransform = false
	pass

func _body_entered(body:Node):
	if (rigid_element.linear_velocity.length() > audio_velocity_threshold):
		# print("_body_entered: ", note_value)

		# move_vector = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		move_vector = move_vector.bounce(body.position.normalized())
		is_launched = false

	if notes_dictionary.keys().size() > 0 and note_value >= 0:
		position.distance_to(Vector3.ZERO)
		timer.stop()
		midi_out.send_message([0x80, note_to_stop, 127])
		# turn off
		var note_position = (global_position.y + 4) / 8
		if note_position < 0:
			note_position = 0
		if note_position > 1:
			note_position = 1
		# var new_note = note_value
		var random_note_index = randi_range(0, notes_dictionary.size() - 1)
		var new_note = notes_dictionary.keys()[random_note_index]
		note_to_stop = new_note
		midi_out.send_message([0x80, note_to_stop, 127])
		# play sound
		var note_loudness = round(rigid_element.linear_velocity.length() * 25)
		if note_loudness > 64:
			note_loudness = 64
		# if relative_point:
		# 	note_loudness = round(5*global_position.distance_to(relative_point.global_position))
		# 	if note_loudness > 127:
		# 		note_loudness = 127
		midi_out.send_message([0x90, new_note, note_loudness])
		# panning
		var pan_value = 64
		midi_out.send_message([0xB0, 10, pan_value])
		timer.start()

	pass # Replace with function body.


func _integrate_forces(state):
	# if resetTransform:
	# 	print("resetTransform")
	# 	rigid_element.state.transform = initialTransform
	# 	resetTransform = false

	direction = direction.normalized()
	var velocity = rigid_element.speed * direction
	var vel_min = rigid_element.linear_velocity.normalized() * 0.1
	var vel_max = rigid_element.linear_velocity.normalized() * 0.18
	rigid_element.linear_velocity = rigid_element.linear_velocity.clamp(vel_min,vel_max)

	# Alternative clamp method
	#linear_velocity = linear_velocity.normalized() * 0.1

	var collision = rigid_element.move_and_collide(velocity)
	if collision:
		direction = direction.bounce(collision.get_normal())
		# print(linear_velocity.length())