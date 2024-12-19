extends Node3D

@export var midi_port_in = 1
@export var midi_port_out = 1

var notes_dictionary = {}
var midi_out = MidiOut.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	midi_out.open_port(midi_port_out)
	print(get_children())
	for sphere in get_children():
		sphere.get_node("Node3D").connect("play_midi_note", Callable(self, "play_midi_note"))
		sphere.get_node("Node3D").connect("receive_midi_note", Callable(self, "receive_midi_note"))
	pass # Replace with function body.

func receive_midi_note(note_value, midi_event):
	var fixed_note_value = note_value
	if midi_event.message == 9:
			notes_dictionary[note_value] = fixed_note_value
	elif midi_event.message == 8:
		notes_dictionary.erase(fixed_note_value)

func play_midi_note(note_value, note_loudness):
	if notes_dictionary.keys().size() > 0 and note_value >= 0:
		midi_out.send_message([0x80, note_value, 127])
		# var new_note = note_value
		
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.1
		timer.timeout.connect(
			func():
				midi_out.send_message([0x80, note_value, 127])
				timer.queue_free()
		)
		add_child(timer)
		timer.start()

		var random_note_index = randi_range(0, notes_dictionary.size() - 1)
		var new_note = notes_dictionary.keys()[random_note_index]
		# note_to_stop = new_note
		# midi_out.send_message([0x80, note_to_stop, 127])
		# play sound
		if note_loudness > 64:
			note_loudness = 64
		# if relative_point:
		# 	note_loudness = round(5*global_position.distance_to(relative_point.global_position))
		# 	if note_loudness > 127:
		# 		note_loudness = 127
		
		print("play_midi_note: ", notes_dictionary.keys())
		midi_out.send_message([0x90, new_note, note_loudness])
		# panning
		# var pan_value = 64
		# midi_out.send_message([0xB0, 10, pan_value])
		# timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
