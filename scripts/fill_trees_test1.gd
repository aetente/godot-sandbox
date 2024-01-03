@tool
extends Node3D


@export var tree : PackedScene
@export var amount_of_trees : int = 100
@export var tree_distance_x : float = 1.0
@export var tree_frequency_x : float = 54365421
@export var tree_distance_z : float = 1.0
@export var tree_frequency_z : float = 23452345
@export var tree_distance_y : float = 0.0
@export var tree_frequency_y : float = 100.0

@export var tree_max_scale : float = 1.0
@export var tree_min_scale : float = 1.0
@export var tree_scale_frequency : float = 100.0

func create_instance(add):
	var scene_instance = add.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(amount_of_trees):
		var tree_element
		tree_element = create_instance(tree)
		tree_element.position.x = tree_distance_x * sin(i * tree_frequency_x)
		tree_element.position.z = tree_distance_z * cos(i * tree_frequency_z)
		
		var tree_scale_value = (tree_max_scale - tree_min_scale) * (sin(tree_scale_frequency * i) + 1) / 2 + tree_min_scale
		tree_element.scale = Vector3(tree_scale_value,tree_scale_value,tree_scale_value)
		tree_element.position.y = tree_distance_y * sin(i * tree_frequency_y) + tree_scale_value / 2
		tree_element.rotation.y = 360 * cos(i * 23452345)
		add_child(tree_element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
