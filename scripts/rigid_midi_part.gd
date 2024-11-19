extends RigidBody3D

@export var audio_velocity_threshold = 0.5

var rng = RandomNumberGenerator.new()

@export var current_note = 0

@export var add_volume_force = 0;
@export var adjust_volume = 0

@export var is_debug = false

@export var midi_port = 1

var is_playing = false

var midi_out = MidiOut.new()


var chord_to_note = preload("res://scripts/chord_to_note.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	chord_to_note = chord_to_note.new()
	midi_out.open_port(midi_port)
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_body_entered)
	pass # Replace with function body.

# func fade_in():
# 	tween.tween_property(audio_streamer, "volume_db", audio_default_volume_db, transition_duration).set_trans(transition_type)

func _on_audio_streamer_finished():
	is_playing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b

func _body_entered(body:Node):
	if (linear_velocity.length() > audio_velocity_threshold):
		if is_debug:
			print("sound")
		# turn off
		var new_note = chord_to_note.chord_to_note()
		midi_out.send_message([0x80, 72, 127])
		# play sound
		midi_out.send_message([0x90, new_note, 127])
		midi_out.send_message([0xB0, 10, randi_range(0, 127)])
	pass # Replace with function body.
