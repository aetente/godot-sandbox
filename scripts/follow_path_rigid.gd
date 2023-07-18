extends Node3D

@onready var path = get_node('./Path3D')
var path_points
var point_index = 0
var point_indexes = []
var rigids = []
var time_alive = []
@export var move_speed: float = 0.4
var velocity = Vector3.ZERO
@export var max_time : float = 30
@export var max_mesh : int = 10

@export var rigids_freq : float = 2
@export var noise_freq : float = -0.7
@export var point_radius : float = 0.3
@export var show_points : bool = false

@export var mesh_model : PackedScene

var time_start = 0
var time_now = 0

func create_instance(add):
	var scene_instance = add.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()
	if (path):
		path_points = path.curve.get_baked_points()
		if show_points:
			for i in range(path.curve.point_count):
				var mesh = MeshInstance3D.new()
				mesh.mesh = SphereMesh.new()
				mesh.position = path.curve.get_point_position(i) + path.position
				mesh.scale = Vector3.ONE * point_radius
				
				add_child(mesh) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	time_now = Time.get_unix_time_from_system()
	if (path):
		if (rigids.size() < max_mesh && time_now - time_start >= rigids_freq + randf()*noise_freq):
			var rigid = create_instance(mesh_model)
			rigids.push_front(rigid)
			point_indexes.push_front(0)
			time_alive.push_front(Time.get_unix_time_from_system())
			add_child(rigid)
			rigid.position = path.curve.get_point_position(0) + path.position
			time_start = Time.get_unix_time_from_system()
		for i in range(rigids.size()):
			if ((point_indexes[i] || point_indexes[i] == 0) && i < path.curve.point_count):
				point_index = point_indexes[i]
				var rigid = rigids[i]
				var target = path.curve.get_point_position(point_index) + path.position
				if (Time.get_unix_time_from_system() - time_alive[i] >= max_time):
					remove_child(rigid)
					point_indexes.remove_at(i)
					rigids.remove_at(i)
					time_alive.remove_at(i)
				if (rigid.position.distance_to(target) < point_radius):
					point_index = point_index + 1
					point_indexes[i] = point_index
					if (point_index >= path.curve.point_count):
						remove_child(rigid)
						point_indexes.remove_at(i)
						rigids.remove_at(i)
						time_alive.remove_at(i)
					else:
						target = path.curve.get_point_position(point_index) + path.position
						time_alive[i] = Time.get_unix_time_from_system()
				velocity = (target - rigid.position).normalized() * move_speed
				#rigid.look_at_from_position(rigid.position, target - path.position, Vector3.ONE)
				print(velocity)
				rigid.look_at(target)
				#rigid.apply_force(velocity)
				rigid.position += velocity
