extends Area3D

@onready var audio_streamer = find_child("AudioStreamPlayer3D", true, false)

var audio_velocity_threshold = 2
var audio_default_pitch_scale = 1
var audio_default_volume_db = 0

var rng = RandomNumberGenerator.new()

@export var transition_duration = 0.1
@export var transition_type = 1 # TRANS_SINE
@export var current_note = 0

@export_file var audio_source

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(get_children())
	# print(audio_streamer)

	if audio_source:
		audio_streamer.stream = audio_source

	# contact_monitor = true
	# max_contacts_reported = 1
	body_entered.connect(_body_entered)
	pass # Replace with function body.

# func fade_in():
# 	tween.tween_property(audio_streamer, "volume_db", audio_default_volume_db, transition_duration).set_trans(transition_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b

func _body_entered(body:Node):
	print("linear_velocity" in body)
	# if (linear_velocity.length() > audio_velocity_threshold):
	# 	var tween = create_tween()
	# 	# var audio_note = notes[current_note]
	# 	# audio_streamer.stream = audio_note
	# 	# audio_streamer.set_pitch_scale(audio_default_pitch_scale + sin(linear_velocity.length() * 123123123) * 0.5 )
	# 	var speed_based_volume = lerp(-80, 0, sqrt(linear_velocity.length()))
	# 	audio_streamer.set_volume_db(-80)
	# 	tween.tween_property(audio_streamer, "volume_db", speed_based_volume, transition_duration).from(-80).set_trans(transition_type)
	# 	# audio_streamer.set_volume_db( min(0, speed_based_volume) )
	# 	audio_streamer.play()
	# 	# tween.start()
	pass # Replace with function body.
