extends RigidBody3D

@onready var audio_streamer = find_child("AudioStreamPlayer3D", true, false)

@export var audio_velocity_threshold = 0.5
@export var pitch_bend = 0.5
var audio_default_pitch_scale = 1
var audio_default_volume_db = 0

var rng = RandomNumberGenerator.new()

@export var transition_duration = 0.1
@export var transition_type = 1 # TRANS_SINE
@export var current_note = 0

@export var add_volume_force = 0;
@export var adjust_volume = 0

@export_dir var audio_folder
@export_file var audio_source

@export var is_debug = false

var is_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# if (audio_folder):
	# 	# audio_source = audio_folder.get_files()[0]
	# 	var audio_folder_dir = DirAccess.open(audio_folder)
	# 	print(audio_folder_dir.get_files())

	if !audio_streamer:
		audio_streamer = AudioStreamPlayer3D.new()
		audio_streamer.doppler_tracking = 1
		add_child(audio_streamer)
		audio_streamer.finished.connect(_on_audio_streamer_finished)

	if audio_source:
		audio_streamer.stream = load(audio_source)

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
	if (not is_playing and linear_velocity.length() > audio_velocity_threshold):
		if is_debug:
			print("sound")
		var tween = create_tween()
		# var audio_note = notes[current_note]
		# audio_streamer.stream = audio_note
		audio_streamer.set_pitch_scale(audio_default_pitch_scale + sin(linear_velocity.length() * 123123123) * pitch_bend )
		var speed_based_volume = min(0, lerp(-80, 0, sqrt(linear_velocity.length()) + add_volume_force)) + adjust_volume
		audio_streamer.set_volume_db(-80)
		tween.tween_property(audio_streamer, "volume_db", speed_based_volume, transition_duration).from(-80).set_trans(transition_type)
		# audio_streamer.set_volume_db( min(0, speed_based_volume) )
		audio_streamer.play()
		is_playing = true
		# tween.start()
	pass # Replace with function body.
