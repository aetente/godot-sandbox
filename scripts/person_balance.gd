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

@onready var leftLeg = get_node("rigids/torsoEnd/leftFoot")
@onready var rightLeg = get_node("rigids/torsoEnd/rightFoot")

@onready var rigidTorso = get_node("rigids/torso")
@onready var rigidTorso2 = get_node("rigids/torsoEnd")

@onready var base = $"rigids"
@onready var body = $"rigids/torso"
@onready var bodyControll = $BodyControll
@onready var torsoEnd = $"rigids/torsoEnd"
@onready var ray = $"rigids/torsoEnd/RayCast3D"

@onready var mainJoint = get_node("torsoJoint")

var walkSpeed = 0.1
var walkAnimationTimer = 0
var isWalking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_unix_time_from_system()
	
func animateWalk():
	walkAnimationTimer += 0.1
	leftLeg.rotation.z = sin(walkAnimationTimer) * 1
	rightLeg.rotation.z = -sin(walkAnimationTimer) * 1

func handleWalk():
	isWalking = false
	
	if Input.is_action_pressed("KEY_W"):
		base.position += (-bodyControll.transform.basis.z*walkSpeed)
		isWalking = true
		
	if Input.is_action_pressed("KEY_A"):
		base.position += (-bodyControll.transform.basis.x*walkSpeed)
		isWalking = true
		
	if Input.is_action_pressed("KEY_D"):
		base.position += (bodyControll.transform.basis.x*walkSpeed)
		isWalking = true
		
	if Input.is_action_pressed("KEY_S"):
		base.position += (bodyControll.transform.basis.z*walkSpeed)
		isWalking = true
		
	if isWalking:
		animateWalk()
	else:
		walkAnimationTimer = 0
		leftLeg.rotation.z = 0
		rightLeg.rotation.z = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = Time.get_unix_time_from_system()
	var r = time_now - time_start
	if ray.is_colliding():
		var normUp = (ray.target_position.y - ray.get_collision_point().distance_to(torsoEnd.transform.origin)) / ray.target_position.y
		if normUp < 0:
			normUp = 0
		var upForce = Vector3(0,1,0) * 0.7 * normUp
		torsoEnd.apply_central_impulse(upForce)
	handleWalk()
	
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
