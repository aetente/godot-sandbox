extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var FLAG_ENABLE_MOTOR = 4
var FLAG_ENABLE_ANGULAR_LIMIT = 1
var F = 340
var stepsF = 0.5;
var steppedR = false;
var steppedL = false;
var stepFreq = 0.5;

var time_start = 0
var time_now = 0

@onready var leftHand = get_node("rigids/leftHand")
@onready var rightHand = get_node("rigids/rightHand")

@onready var leftFoot = get_node("rigids/leftFoot")
@onready var rightFoot = get_node("rigids/rightFoot")

@onready var rigidTorso = get_node("rigids/torso")

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = Time.get_unix_time_from_system()
	var r = time_now - time_start
	var err_pos = rigidTorso.position - (leftHand.position + rightHand.position + leftFoot.position + rightFoot.position) / 4;
	
	#print(rigidTorso.position, err_pos)
	rigidTorso.position.x -= err_pos.x / 1;
	rigidTorso.position.z -= err_pos.z / 1;
	rigidTorso.position.y -= err_pos.y / 1;
	
	if Input.is_action_pressed("KEY_E"):
		
		var force_value = Vector3(0,F,F/50)
		leftHand.apply_force(force_value.rotated(Vector3(0,1,0), rigidTorso.rotation.y), Vector3(0,0,0))
	if Input.is_action_pressed("KEY_Q"):
		
		var force_value2 = Vector3(0,F,-F/50)
		rightHand.apply_force(force_value2.rotated(Vector3(0,1,0), rigidTorso.rotation.y), Vector3(0,0,0))
	
	if Input.is_action_pressed("KEY_W"):
		var force_value3 = Vector3(0,F * 1,0)
		rigidTorso.apply_force(force_value3, Vector3(0,0,0))
	if Input.is_action_pressed("KEY_S"):
		var force_value4 = Vector3(0,-F * 5,0)
		rigidTorso.apply_force(force_value4, Vector3(0,0,0))
	
	var mlscnds = fmod(r, stepFreq);
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		if mlscnds < (stepFreq / 2) && !steppedL:
			#leftFoot.apply_force(Vector3(F*stepsF,0,0).rotated(Vector3(0,1,0), rigidTorso.rotation.y), Vector3(0,0,0))
			rigidTorso.apply_force(Vector3(F*stepsF*5,0,0).rotated(Vector3(0,1,0), rigidTorso.rotation.y), Vector3(0,0,0))
			leftFoot.apply_torque(Vector3(0,0,F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			rightFoot.apply_torque(Vector3(0,0,-F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			leftHand.apply_torque(Vector3(0,0,F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			rightHand.apply_torque(Vector3(0,0,-F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			steppedR = false;
			steppedL = true;
		elif mlscnds >= (stepFreq / 2) && !steppedR:
			leftFoot.apply_torque(Vector3(0,0,-F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			rightFoot.apply_torque(Vector3(0,0,F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			#leftFoot.apply_force(Vector3(-F*stepsF,0,0).rotated(Vector3(0,1,0), rigidTorso.rotation.y), Vector3(0,0,0))
			rightHand.apply_torque(Vector3(0,0,F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			leftHand.apply_torque(Vector3(0,0,-F*stepsF).rotated(Vector3(0,1,0), rigidTorso.rotation.y))
			steppedL = false;
			steppedR = true;
	
	if Input.is_action_pressed("ui_right"):
		rigidTorso.rotation += Vector3(0,-0.1,0);
	if Input.is_action_pressed("ui_left"):
		rigidTorso.rotation += Vector3(0,0.1,0);
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
