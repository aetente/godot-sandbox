extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var FLAG_ENABLE_MOTOR = 4
var FLAG_ENABLE_ANGULAR_LIMIT = 1
var F = 340

var time_start = 0
var time_now = 0


@onready var leftLeg = get_node("rigids/leftFoot")
@onready var rightLeg = get_node("rigids/rightFoot")

@onready var base = $"rigids"
@onready var body = $"rigids/torsoEnd/torso"
@onready var bodyControll = $BodyControll
@onready var torsoEnd = $"rigids/torsoEnd"
@onready var leftFoot = $"rigids/leftFoot/leftFootEnd"
@onready var rightFoot = $"rigids/rightFoot/rightFootEnd"

@onready var mainJoint = get_node("torsoJoint")

var walkForce = 0.1
var walkAnimationTimer = 0
var isWalking = false

var leftFootStartPos = Vector3(0,0,0)
var rightFootStartPos = Vector3(0,0,0)

var leftLegDesiredAngle = Vector3(0,0,0)
var rightLegDesiredAngle = Vector3(0,0,0)

var movedRightLeg = false
var movedLeftLeg = false

var movingDirection = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	leftFootStartPos = leftFoot.position
	rightFootStartPos = rightFoot.position
	leftLegDesiredAngle = leftLeg.desired_angle
	rightLegDesiredAngle = rightLeg.desired_angle
	time_start = Time.get_unix_time_from_system()
	
func animateWalk():
	walkAnimationTimer += 0.1
	if (sin(walkAnimationTimer) > 0 && !movedRightLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 0.1
		movedRightLeg = true
		movedLeftLeg = false
		leftLeg.desired_angle.z = 1 * movingDirection.x
		rightLeg.desired_angle.z = 0 * movingDirection.x
		pass
	elif (sin(walkAnimationTimer) <= 0 && !movedLeftLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 0.1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 1
		movedRightLeg = false
		movedLeftLeg = true
		leftLeg.desired_angle.z = 0 * movingDirection.x
		rightLeg.desired_angle.z = 1 * movingDirection.x
		pass
	#leftFoot.position.y += (sin(walkAnimationTimer) + 1) / 20 * 1
	#leftFoot.position.x += (cos(walkAnimationTimer)) / 20 * 1
	#rightFoot.position.y += -(sin(walkAnimationTimer) + 1) / 20 * 1
	#rightFoot.position.x += -(cos(walkAnimationTimer)) / 20 * 1

func handleWalk():
	isWalking = false
	movingDirection = Vector2(0,0)
	
	#body.rotation.z = 0
	if Input.is_action_pressed("KEY_W"):
		movingDirection.x += 1
		#torsoEnd.desired_angle.z = -PI / 4
		body.apply_central_impulse(-bodyControll.transform.basis.z*walkForce)
		isWalking = true
		
	if Input.is_action_pressed("KEY_A"):
		movingDirection.y -= 1
		body.apply_central_impulse(-bodyControll.transform.basis.x*walkForce * 10)
		isWalking = true
		
	if Input.is_action_pressed("KEY_D"):
		movingDirection.y += 1
		body.apply_central_impulse(bodyControll.transform.basis.x*walkForce * 10)
		isWalking = true
		
	if Input.is_action_pressed("KEY_S"):
		movingDirection.x -= 1
		body.apply_central_impulse(bodyControll.transform.basis.z*walkForce)
		isWalking = true
		
	if isWalking:
		animateWalk()
		pass
	else:
		walkAnimationTimer = 0
		movedRightLeg = false
		movedLeftLeg = false
		movingDirection = Vector2(0,0)
		leftLeg.desired_angle = leftLegDesiredAngle 
		rightLeg.desired_angle = rightLegDesiredAngle
		#leftLeg.rotation.z = 0
		#rightLeg.rotation.z = 0
		#leftFoot.position = leftFootStartPos
		#rightFoot.position = rightFootStartPos
		
func handleBalance(ray):
	if ray.is_colliding():
		var distanceToGround = ray.get_collision_point().distance_to(torsoEnd.transform.origin)
		#if (distanceToGround < 1):
		#	torsoEnd.position.y = ray.target_position.y
		#else:
		var normUp = (ray.target_position.y - distanceToGround) / ray.target_position.y
		if normUp < 0:
			normUp = 0
		var upForce = Vector3(0,1,0) * 0.7 * normUp
		torsoEnd.apply_central_impulse(upForce)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = Time.get_unix_time_from_system()
	var r = time_now - time_start
	handleWalk()
	
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
