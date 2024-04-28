extends RigidBody3D

@onready var audio_streamer = $"../AudioStreamPlayer3D"

var c_note = preload("res://assets/audio/tests/c.mp3")
var d_note = preload("res://assets/audio/tests/d.mp3")
var e_note = preload("res://assets/audio/tests/e.mp3")
var f_note = preload("res://assets/audio/tests/f.mp3")
var g_note = preload("res://assets/audio/tests/g.mp3")
var a_note = preload("res://assets/audio/tests/a.mp3")
var b_note = preload("res://assets/audio/tests/b.mp3")

var notes = [c_note, d_note, e_note, f_note, g_note, a_note, b_note]

var audio_velocity_threshold = 0.01
var audio_default_pitch_scale = 1
var audio_default_volume_db = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b

func _on_body_entered(body:Node):
	if (linear_velocity.length() > audio_velocity_threshold):
		
		var audio_note = notes[rng.randi_range(0, notes.size() - 1)]
		audio_streamer.stream = audio_note
		# audio_streamer.set_pitch_scale(audio_default_pitch_scale + sin(linear_velocity.length() * 123123123) * 0.5 )
		audio_streamer.set_volume_db( min(0, lerp(-40, 0, sqrt(linear_velocity.length()))) )
		audio_streamer.play()
	pass # Replace with function body.


func _on_audio_stream_player_3d_finished():
	pass # Replace with function body.
