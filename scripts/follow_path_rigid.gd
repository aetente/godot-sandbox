extends Node3D

@onready var path = get_node('./Path3D')
var path_points
var point_index = 0
var rigid
var move_speed = 0.1
var velocity = Vector3.ZERO

func create_instance(add):
	var scene = load(add)
	var scene_instance = scene.instantiate()
	return scene_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	rigid = create_instance('res://elements/test_mesh.tscn')
	add_child(rigid)
	
	if (path):
		path_points = path.curve.get_baked_points()
		rigid.position = path.curve.get_point_position(point_index)
		for i in range(path.curve.point_count):
			var mesh = MeshInstance3D.new()
			mesh.mesh = SphereMesh.new()
			mesh.position = path.curve.get_point_position(i)
			mesh.scale = Vector3.ONE * 0.3
			
			add_child(mesh) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if (path):
		var target = path.curve.get_point_position(point_index)
		if (rigid.position.distance_to(target) < 0.3):
			point_index = wrapi(point_index + 1, 0, path.curve.point_count)
			print(point_index, ' : ', path.curve.point_count)
			target = path.curve.get_point_position(point_index)
		velocity = (target - rigid.position).normalized() * move_speed
		var angle = rigid.position.angle_to(target)
		rigid.look_at(target)
		#rigid.apply_force(velocity)
		rigid.position += velocity
