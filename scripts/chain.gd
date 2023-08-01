@tool
extends Node3D

@export var cell : PackedScene
@export var front_cell : PackedScene
@export var back_cell : PackedScene

@export var amount_of_cells : int = 6
@export var cell_distance : float = 5
@export var joint_offset : Vector3 = Vector3(0,0,0)

@export var debug_draw : bool = false

func create_instance(add):
	var scene_instance = add.instantiate()
	return scene_instance

var rigids = []
var joints = []
var meshes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = get_node("./PinJoint3D")
	for i in range(amount_of_cells):
		var cell_element
		if (i == 0 && front_cell):
			cell_element = create_instance(front_cell)
		if (i == amount_of_cells - 1 && back_cell):
			cell_element = create_instance(back_cell)
		else:
			cell_element = create_instance(cell)
		cell_element.position.x = float(i) * cell_distance
		add_child(cell_element)
		rigids.push_back(cell_element)
		
		if (i != 0):
			var joint = PinJoint3D.new()
			joint.node_a = rigids[i - 1].get_path()
			joint.node_b = rigids[i].get_path()
			var joint_position = (rigids[i - 1].position + rigids[i].position) / 2. + joint_offset
			joint.position = joint_position
			add_child(joint)
			joints.push_back(joint)
			if (debug_draw):
				var mesh = MeshInstance3D.new()
				mesh.mesh = SphereMesh.new()
				mesh.position = joint.position
				mesh.scale = Vector3.ONE * 1
				add_child(mesh)
				meshes.push_back(mesh)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (debug_draw && len(meshes) > 0):
		for i in range(len(meshes)):
			meshes[i].position = joints[i].position
			#meshes[i].position.y += 1
	#print(meshes[0].position)
