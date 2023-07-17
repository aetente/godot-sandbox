extends Node3D

@onready var path = get_node('./Path3D')
var path_points
var point_index = 0
var point_indexes = []
var rigids = []
var move_speed = 0.1
var velocity = Vector3.ZERO

const amount_of_rigis = 10
const rigids_freq = 0.3

var time_start = 0
var time_now = 0

func create_instance(add):
	var scene = load(add)
	var scene_instance = scene.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()
	if (path):
		path_points = path.curve.get_baked_points()
		for i in range(path.curve.point_count):
			var mesh = MeshInstance3D.new()
			mesh.mesh = SphereMesh.new()
			mesh.position = path.curve.get_point_position(i) + path.position
			mesh.scale = Vector3.ONE * 0.3
			
			add_child(mesh) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	time_now = Time.get_unix_time_from_system()
	if (time_now - time_start >= rigids_freq):
		var rigid = create_instance('res://elements/test_mesh.tscn')
		rigid.position = path.curve.get_point_position(0)
		rigids.push_front(rigid)
		point_indexes.push_front(0)
		add_child(rigid)
		time_start = Time.get_unix_time_from_system()
	if (path):
		for i in range(rigids.size()):
			point_index = point_indexes[i]
			var rigid = rigids[i]
			var target = path.curve.get_point_position(point_index) + path.position
			if (rigid.position.distance_to(target) < 0.3):
				point_index = point_index + 1
				point_indexes[i] = point_index
				if (point_index >= path.curve.point_count):
					remove_child(rigid)
					point_indexes.remove_at(i)
					rigids.remove_at(i)
				target = path.curve.get_point_position(point_index) + path.position
			velocity = (target - rigid.position).normalized() * move_speed
			rigid.look_at(target)
			#rigid.apply_force(velocity)
			rigid.position += velocity
