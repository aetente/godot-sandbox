extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var FLAG_ENABLE_MOTOR = 4
var FLAG_ENABLE_ANGULAR_LIMIT = 1
var F = 340

var time_start = 0
var time_now = 0

#onready var prearm1Torso = get_node("prearm1Torso")
#onready var prearm2Torso = get_node("prearm2Torso")

@onready var rigidTorso = get_node("rigids/torso")
@onready var rigidTorso2 = get_node("rigids/torsoEnd")
@onready var base = get_node("base")


@onready var mainJoint = get_node("torsoJoint")

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = Time.get_unix_time_from_system()
	var r = time_now - time_start
	
	#if Input.is_action_pressed("KEY_X"):
		#mainJoint.set_flag_x(FLAG_ENABLE_ANGULAR_LIMIT, false)
		#mainJoint.set_flag_y(FLAG_ENABLE_ANGULAR_LIMIT, false)
		#mainJoint.set_flag_z(FLAG_ENABLE_ANGULAR_LIMIT, false)
	#else:
		#mainJoint.set_flag_x(FLAG_ENABLE_ANGULAR_LIMIT, true)
		#mainJoint.set_flag_y(FLAG_ENABLE_ANGULAR_LIMIT, true)
		#mainJoint.set_flag_z(FLAG_ENABLE_ANGULAR_LIMIT, true)
	var min_random = -20;
	var max_random = 20;
	var random_force = Vector3(
		randf_range(min_random,max_random),
		randf_range(min_random,max_random),
		randf_range(min_random,max_random)
	)
	rigidTorso.apply_force(random_force, Vector3(0,0,0))
	
	
	if Input.is_action_pressed("KEY_W"):
		var force_value3 = Vector3(0,F * 1,0)
		rigidTorso.apply_force(force_value3, Vector3(0,0,0))
		#rigidTorso2.apply_force(force_value3, Vector3(0,0,0))
	if Input.is_action_pressed("KEY_S"):
		var force_value4 = Vector3(0,-F * 5,0)
		rigidTorso.apply_force(force_value4, Vector3(0,0,0))
		#rigidTorso2.apply_force(force_value4, Vector3(0,0,0))
	
	if Input.is_action_pressed("ui_up"):
		base.position += Vector3(0.2,0,0).rotated(Vector3(0,1,0), base.rotation.y);
	if Input.is_action_pressed("ui_down"):
		base.position += Vector3(-0.1,0,0).rotated(Vector3(0,1,0), base.rotation.y)
	
	
	if Input.is_action_pressed("ui_right"):
		base.rotation += Vector3(0,-0.01,0);
	if Input.is_action_pressed("ui_left"):
		base.rotation += Vector3(0,0.01,0);
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
