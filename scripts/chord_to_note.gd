extends Node

var STRING_NOTES = [48, 50, 52, 53, 55, 57, 59]  #c, d, e, f, g, a, b
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
	'M': [0,4,7],
	'm': [0,3,7],
	'dim': [0,3,6],
	'dim7': [0,3,6],
	'7': [0,4,7,10],
	'M7': [0,4,7,11],
	'm7': [0,3,7,10],
	'sus2': [0,2,7],
	'sus4': [0,5,7],
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

func chord_to_note():
  
  var chords_array = Global.TEST_CHORDS.split(',')
  var current_chord = Global.current_chord
  
  var base_note_string = ''
  var chord_type = ''
  # get base note (C) and type of chord (m or minor)
  for l in range(len(chords_array[current_chord])):
    if (l == 0):
      base_note_string += chords_array[current_chord][l]
    elif (chords_array[current_chord][l] == '#' or chords_array[current_chord][l] == 'b'):
      base_note_string += chords_array[current_chord][l]
    else:
      chord_type += chords_array[current_chord][l]
  if (chord_type == ''):
    chord_type = 'M'
  # get number for base note
  var base_note = CHROMATIC_SCALE[base_note_string]
  # convert current note in range from 0 to 12
  #modulo_note = flp.score.getNote(i).number % 12
  var chord_notes = CHORDS
  var note_number = randi_range(0, len(chord_notes[chord_type]) - 1)
  return base_note + chord_notes[chord_type][note_number] + 48
