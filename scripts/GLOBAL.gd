extends Node

#var TEST_CHORDS = 'Cm,Cm,Fm,Fm,Fdim,Fdim,Cm,Cm,Ab,Ab,D7,D7,Gm,Gm,C7,C7,Fm,Fm,Bb7,Bb7,Eb,Eb,Ab,Ab,Bb7,Bb7,Eb,Eb,F7,F7,Ddim7,Ddim7,Cm,Eb,Fm7,Fm7,Adim7,Adim7,Cm,Cm,Adim7,Adim7,Cm,Cm,Ab,Ab,G7'
# var TEST_CHORDS = 'Ab,Fm7(no5),Bbm7(no5),Eb,Ab,Fm7(no5),Bbm7(no5),Eb,Ab,Db,AbM7(no5),Bbm7(no5)'
# var TEST_CHORDS = 'AbM7/Eb,Fm7(no5),C#M7(no3),Cm7(no3)'
# var TEST_CHORDS = 'AbM7/Eb'
# var TEST_CHORDS = 'F#6add9,G#7,A#7,G#m/B'
var TEST_CHORDS = 'B6add9/G#' # bass line B, G#, C#, F#
var chords_array = TEST_CHORDS.split(',')

var current_chord = 0

func reset_chord():
  print("reset chord")
  current_chord = 0

func update_chord():
  current_chord = (current_chord + 1) % len(chords_array)
  print("current_chord: ", chords_array[current_chord],  " ", current_chord)