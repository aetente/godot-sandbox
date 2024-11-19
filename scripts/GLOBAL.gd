extends Node

var TEST_CHORDS = 'Cm,Cm,Fm,Fm,Fdim,Fdim,Cm,Cm,Ab,Ab,D7,D7,Gm,Gm,C7,C7,Fm,Fm,Bb7,Bb7,Eb,Eb,Ab,Ab,Bb7,Bb7,Eb,Eb,F7,F7,Ddim7,Ddim7,Cm,Eb,Fm7,Fm7,Adim7,Adim7,Cm,Cm,Adim7,Adim7,Cm,Cm,Ab,Ab,G7'
var chords_array = TEST_CHORDS.split(',')

var current_chord = 0

func reset_chord():
  print("reset chord")
  current_chord = 0

func update_chord():
  current_chord = (current_chord + 1) % len(chords_array)
  print("current_chord: ", chords_array[current_chord],  " ", current_chord)