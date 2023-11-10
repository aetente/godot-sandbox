@tool
extends Node3D


@export var tree : PackedScene
@export var amount_of_trees : int = 100

func create_instance(add):
	var scene_instance = add.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(amount_of_trees):
		var tree_element
		tree_element = create_instance(tree)
		tree_element.position.x = sin(i * 342513134)
		tree_element.position.z = cos(i * 23452345)
		tree_element.rotation.y = 360 * cos(i * 23452345)
		add_child(tree_element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
