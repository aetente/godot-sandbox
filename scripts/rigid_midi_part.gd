extends RigidBody3D


@onready var timer = Timer.new()

@export var audio_velocity_threshold = 0.5

var rng = RandomNumberGenerator.new()

@export var current_note = 0

@export var add_volume_force = 0;
@export var adjust_volume = 0

@export var is_debug = false

@export var midi_port = 1

@export var relative_point: Node3D

@export var is_full_chord = false

var is_playing = false

var midi_out = MidiOut.new()

var chord_to_note = preload("res://scripts/chord_to_note.gd")

var note_to_stop = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	timer.one_shot = true
	timer.wait_time = 0.3
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)


	chord_to_note = chord_to_note.new()
	midi_out.open_port(midi_port)
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_body_entered)
	pass # Replace with function body.

	
func _on_timer_timeout():
	midi_out.send_message([0x80, note_to_stop, 127])

# func fade_in():
# 	tween.tween_property(audio_streamer, "volume_db", audio_default_volume_db, transition_duration).set_trans(transition_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b

func _body_entered(body:Node):
	if (linear_velocity.length() > audio_velocity_threshold):
		timer.stop()
		if is_debug:
			print("sound")
		# turn off
		var note_position = (global_position.y + 4) / 8
		if note_position < 0:
			note_position = 0
		if note_position > 1:
			note_position = 1
		var new_note = chord_to_note.chord_to_note(note_position)
		note_to_stop = new_note
		midi_out.send_message([0x80, note_to_stop, 127])
		# play sound
		var note_loudness = 127
		if relative_point:
			note_loudness = round(5*global_position.distance_to(relative_point.global_position))
			if note_loudness > 127:
				note_loudness = 127
		midi_out.send_message([0x90, new_note, note_loudness])
		# panning
		var pan_value = randi_range(0, 127)
		if relative_point:
			pan_value = round((relative_point.global_position.x - global_position.x) * 10) + 64
			if pan_value > 127:
				pan_value = 127
			if pan_value < 0:
				pan_value = 0
			# pan_value = fmod(abs(relative_point.global_position.angle_to(global_position)), 2 * PI) * 127 / (2*PI)
			# print(relative_point.global_position)
			# print(global_position)
			# print(pan_value)
		midi_out.send_message([0xB0, 10, pan_value])
		timer.start()
	pass # Replace with function body.
