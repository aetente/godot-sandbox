extends Node3D

@export var rigid_element : RigidBody3D

# TODO: add notes to dictionary on press note and remove it after note off and play note randomnly from dictionary keys

@export var audio_velocity_threshold = 0

var note_value = -1;

var move_vector = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
var is_launched = false

var initialTransform
var resetTransform = false
@export var speed = 1
var direction = Vector3.ZERO
@export var move_octave_down = 8

signal play_midi_note(note_value, note_loudness)
signal receive_midi_note(note_value, midi_event)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialTransform = rigid_element.transform
	OS.open_midi_inputs()
	
	rigid_element.contact_monitor = true
	rigid_element.max_contacts_reported = 1
	rigid_element.body_entered.connect(_body_entered)
	pass # Replace with function body.

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)

func _print_midi_info(midi_event):
	if (midi_event.pitch > 100):
		note_value = midi_event.pitch - move_octave_down*12
		receive_midi_note.emit(note_value, midi_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_launched):
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
		# move_vector = move_vector.bounce(body.position.normalized())
		is_launched = false
	
	var note_loudness = round(rigid_element.linear_velocity.length() * 25)
	if note_loudness > 32:
		note_loudness = 32
	play_midi_note.emit(note_value, note_loudness)

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