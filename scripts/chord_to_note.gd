extends Node

var NOTES_NUMBER = [48, 50, 52, 53, 55, 57, 59]  #c, d, e, f, g, a, b
var NOTES_STRING = ['c', 'd', 'e', 'f', 'g', 'a', 'b']
var SCALES = {
	'': [0,2,4,5,7,9,11],
	'M': [0,2,4,5,7,9,11],
	'm': [0,2,3,5,7,8,10],
	'dim': [0,3,6],
	'dim7': [0,3,6,9],
	'7': [0,2,4,5,7,9,10],
	'M7': [0,2,4,5,7,9,11],
	'm7': [0,2,3,5,7,8,10]
}
var CHORDS = {
	'': [0,4,7],
	'M': [0,4,7], # -> [4,7,12]
	'm': [0,3,7],
	'dim': [0,3,6],
	'dim7': [0,3,6],
	'7': [0,4,7,10],
	'M7': [0,4,7,11],
	'm7': [0,3,7,10],
	'M7(no3)': [0,7,11],
	'M7(no5)': [0,4,11],
	'm7(no3)': [0,7,10],
	'm7(no5)': [0,3,10],
	'sus2': [0,2,7],
	'sus4': [0,5,7],
	'aug': [0,4,8],
	'6': [0,4,7,9],
	'6add9': [0,4,7,9,14],
	'm6': [0,3,7,9],
	'm6add9': [0,3,7,9,14],
}
var VALID_NOTES = ['A', 'Am', 'A#', 'A#m', 'B', 'Bm', 'C', 'Cm', 'C#', 'C#m', 'D', 'Dm', 'D#', 'D#m', 'E', 'Em', 'F', 'Fm', 'F#', 'F#m', 'G', 'Gm', 'G#', 'G#m']

var CHROMATIC_SCALE = {
	'B#': 0,
	'C': 0,
	'C#': 1,
	'Db': 1,
	'D': 2,
	'D#': 3,
	'Eb': 3,
	'E': 4,
	'E#': 5,
	'Fb': 4,
	'F': 5,
	'F#': 6,
	'Gb': 6,
	'G': 7,
	'G#': 8,
	'Ab': 8,
	'A': 9,
	'A#': 10,
	'Bb': 10,
	'B': 11,
	'Cb': 11,
}
var NATURAL_NOTES = ['A', 'B', 'C', 'D', 'E', 'F', 'G']

var previous_note = 999

func _ready():
	pass

func chord_to_note(relative_position):

	var chords_array = Global.TEST_CHORDS.split(',')
	var chord_and_base = Global.chords_array[Global.current_chord].split('/')
	var current_chord = chord_and_base[0]
	var current_base = chord_and_base[1] if chord_and_base.size() > 1 else null

	var base_note_string = ''
	var chord_type = ''
	# get base note (C) and type of chord (m or minor)
	for l in range(len(current_chord)):
		if (l == 0):
			base_note_string += current_chord[l]
		elif (current_chord[l] == '#' or current_chord[l] == 'b'):
			base_note_string += current_chord[l]
		else:
			chord_type += current_chord[l]
	if (chord_type == ''):
		chord_type = 'M'
	# get number for base note
	var chord_notes = CHORDS
	var chord_values = chord_notes[chord_type]
	var base_note = CHROMATIC_SCALE[base_note_string]
	var slash_base_note_number = 0
	if current_base != null:
		# var chord_values_string = []
		# for i in range(len(chord_values)):
		# 	chord_values_string.push_back(NOTES_STRING[chord_values[i]])
		var old_base_note = base_note
		slash_base_note_number = CHROMATIC_SCALE[current_base]
		# for example chord F will be problematic
		if old_base_note >= 5:
			old_base_note -= 12
		# 9 -> -3
		var base_diff = slash_base_note_number - old_base_note
		# 1 - (-3) = 4
		var shift_chord_by = chord_values.find(base_diff)
		var new_chord_values = []
		if shift_chord_by > 0:
			for i in range(chord_values.size()):
				var shift_index = (i + shift_chord_by) % chord_values.size()
				var value_after_shift = chord_values[shift_index]
				var is_octave_up = value_after_shift < base_diff
				if is_octave_up:
					value_after_shift += 12
				new_chord_values.push_back(value_after_shift)
			chord_values = new_chord_values

	
	var note_number = randi_range(0, len(chord_notes[chord_type]) - 1)
	if relative_position != null:
		note_number = floor(relative_position * chord_values.size())
		if note_number >= len(chord_values):
			note_number = len(chord_values) - 1
	return base_note + chord_values[note_number] + 48
