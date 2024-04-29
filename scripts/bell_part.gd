extends RigidBody3D

@onready var audio_streamer = find_child("AudioStreamPlayer3D", true, false)

var audio_velocity_threshold = 0.01
var audio_default_pitch_scale = 1
var audio_default_volume_db = 0

var rng = RandomNumberGenerator.new()

@export var current_note = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(get_children())
	# print(audio_streamer)
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b

func _body_entered(body:Node):
	if (linear_velocity.length() > audio_velocity_threshold):
		# var audio_note = notes[current_note]
		# audio_streamer.stream = audio_note
		# audio_streamer.set_pitch_scale(audio_default_pitch_scale + sin(linear_velocity.length() * 123123123) * 0.5 )
		audio_streamer.set_volume_db( min(0, lerp(-40, 0, sqrt(linear_velocity.length()))) )
		audio_streamer.play()
	pass # Replace with function body.
