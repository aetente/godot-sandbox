extends Node3D

var people_elements;
var people_positions = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	var people = get_node('./people')
	people_elements = people.get_children()
	for i in range(len(people_elements)):
		var p = people_elements[i]
		people_positions.push_back(p.get_node("base/static_base").position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if people_positions && people_elements && Input.is_action_pressed("KEY_R"):
		for i in range(len(people_elements)):
			var p = people_elements[i]
			var person_position = people_positions[i]
			p.get_node("base/static_base").position = person_position
