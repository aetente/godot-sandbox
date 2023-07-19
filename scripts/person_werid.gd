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

@onready var rigidPrearm1 = get_node("rigids/leftHand")
@onready var rigidPrearm2 = get_node("rigids/rightHand")

@onready var rigidArm1 = get_node("rigids/leftHandEnd")
@onready var rigidArm2 = get_node("rigids/rightHandEnd")

@onready var rigidKnee1 = get_node("rigids/leftFoot")
@onready var rigidKnee2 = get_node("rigids/rightFoot")

@onready var rigidTorso = get_node("rigids/torso")
@onready var rigidTorso2 = get_node("rigids/torsoEnd")
@onready var base = get_node("base/static_base")


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
	
	if Input.is_action_pressed("KEY_E"):
		#prearm1Torso.set_flag_z(FLAG_ENABLE_MOTOR, !prearm1Torso.get_flag_z(FLAG_ENABLE_MOTOR))
		#prearm1Torso.set_flag_y(FLAG_ENABLE_MOTOR, !prearm1Torso.get_flag_y(FLAG_ENABLE_MOTOR))
		#rigidPrearm1.add_force(Vector3(F,F,F).rotated(Vector3(0,1,0), base.rotation.y + deg2rad(180)), rigidTorso.translation)
		#rigidArm1.add_force(Vector3(F,F,F).rotated(Vector3(0,1,0), base.rotation.y + deg2rad(180)), rigidTorso.translation)
		
		var force_value = Vector3(0,F,F/50)
		rigidPrearm1.apply_force(force_value.rotated(Vector3(0,1,0), base.rotation.y), Vector3(0,0,0))
		rigidArm1.apply_force(force_value.rotated(Vector3(0,1,0), base.rotation.y), Vector3(0,0,0))
	if Input.is_action_pressed("KEY_Q"):
		#prearm2Torso.set_flag_x(FLAG_ENABLE_MOTOR, !prearm2Torso.get_flag_x(FLAG_ENABLE_MOTOR))
		#prearm2Torso.set_flag_y(FLAG_ENABLE_MOTOR, !prearm2Torso.get_flag_y(FLAG_ENABLE_MOTOR))
		#rigidPrearm2.add_force(Vector3(F,F,-F).rotated(Vector3(0,1,0), base.rotation.y + deg2rad(180)), rigidTorso.translation)
		#rigidArm2.add_force(Vector3(F,F,-F).rotated(Vector3(0,1,0), base.rotation.y + deg2rad(180)), rigidTorso.translation)
		
		var force_value2 = Vector3(0,F,-F/50)
		rigidPrearm2.apply_force(force_value2.rotated(Vector3(0,1,0), base.rotation.y), Vector3(0,0,0))
		rigidArm2.apply_force(force_value2.rotated(Vector3(0,1,0), base.rotation.y), Vector3(0,0,0))
	
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
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		if randf() < 0.1:
			rigidKnee1.apply_force(Vector3(0,0,F*3).rotated(Vector3(0,1,0), base.rotation.y + deg_to_rad(90)), Vector3(0,0,0))
			rigidKnee2.apply_force(Vector3(0,0,-F*2).rotated(Vector3(0,1,0), base.rotation.y + deg_to_rad(90)), Vector3(0,0,0))
		elif randf() > 0.9:
			rigidKnee2.apply_force(Vector3(0,0,F*3).rotated(Vector3(0,1,0), base.rotation.y + deg_to_rad(90)), Vector3(0,0,0))
			rigidKnee1.apply_force(Vector3(0,0,-F*2).rotated(Vector3(0,1,0), base.rotation.y + deg_to_rad(90)), Vector3(0,0,0))
	
	if Input.is_action_pressed("ui_right"):
		base.rotation += Vector3(0,-0.1,0);
	if Input.is_action_pressed("ui_left"):
		base.rotation += Vector3(0,0.1,0);
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
