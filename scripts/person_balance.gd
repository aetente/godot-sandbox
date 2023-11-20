extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var FLAG_ENABLE_MOTOR = 4
var FLAG_ENABLE_ANGULAR_LIMIT = 1
var F = 340

var time_start = 0
var time_now = 0

@onready var base = $"rigids"
@onready var body = $"rigids/torsoEnd/torso"
@onready var head = $"rigids/torsoEnd/torso/head"
@onready var torsoEnd = $"rigids/torsoEnd"

@onready var leftFoot = $"rigids/leftFoot/leftFootEnd"
@onready var rightFoot = $"rigids/rightFoot/rightFootEnd"
@onready var leftLeg = $"rigids/leftFoot"
@onready var rightLeg = $"rigids/rightFoot"

@onready var leftArm = $"rigids/torsoEnd/torso/leftArm"
@onready var rightArm = $"rigids/torsoEnd/torso/rightArm"
@onready var leftHandEnd = $"rigids/torsoEnd/torso/leftHandEnd"
@onready var rightHandEnd = $"rigids/torsoEnd/torso/rightHandEnd"


@onready var cameraPivot = $"CameraPivot"

var walkForce = 0.1
var walkAnimationTimer = 0
var isWalking = false

var leftLegDesiredAngle = Vector3(0,0,0)
var rightLegDesiredAngle = Vector3(0,0,0)
var torsoEndDesiredAngle = Vector3(0,0,0)

var previousCameraPivotAngle = Vector3(0,0,0)
var cameraPivotAngleDifference = Vector3(0,0,0)

var movedRightLeg = false
var movedLeftLeg = false

var movingDirection = Vector2(0,0)

var mouse_sensitivity = 0.3
var max_angle_forward = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	leftLegDesiredAngle = leftLeg.desired_angle
	rightLegDesiredAngle = rightLeg.desired_angle
	torsoEndDesiredAngle = torsoEnd.desired_angle
	
	previousCameraPivotAngle = cameraPivot.rotation
	time_start = Time.get_unix_time_from_system()
	
func animateWalk():
	walkAnimationTimer += 0.2
	torsoEnd.desired_angle.z = -abs(movingDirection.x) / 2
	if (sin(walkAnimationTimer) > 0 && !movedRightLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 0.1
		movedRightLeg = true
		movedLeftLeg = false
		leftLeg.desired_angle.z = max_angle_forward * movingDirection.x
		rightLeg.desired_angle.z = 0 * movingDirection.x
		pass
	elif (sin(walkAnimationTimer) <= 0 && !movedLeftLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 0.1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 1
		movedRightLeg = false
		movedLeftLeg = true
		leftLeg.desired_angle.z = 0 * movingDirection.x
		rightLeg.desired_angle.z = max_angle_forward * movingDirection.x
		pass
	#leftFoot.position.y += (sin(walkAnimationTimer) + 1) / 20 * 1
	#leftFoot.position.x += (cos(walkAnimationTimer)) / 20 * 1
	#rightFoot.position.y += -(sin(walkAnimationTimer) + 1) / 20 * 1
	#rightFoot.position.x += -(cos(walkAnimationTimer)) / 20 * 1
	
func handleRotation():
	#torsoEnd.rotation.y = cameraPivot.rotation.y
	cameraPivotAngleDifference = cameraPivot.rotation - previousCameraPivotAngle
	
	leftLegDesiredAngle.y += cameraPivotAngleDifference.y
	rightLegDesiredAngle.y += cameraPivotAngleDifference.y
	torsoEndDesiredAngle.y += cameraPivotAngleDifference.y
	
	#base.rotation.y += cameraPivotAngleDifference.y
	#head.desired_angle.y += cameraPivotAngleDifference.y
	
	body.desired_angle.y += cameraPivotAngleDifference.y
	torsoEnd.desired_angle.y += cameraPivotAngleDifference.y
	leftLeg.desired_angle.y += cameraPivotAngleDifference.y
	rightLeg.desired_angle.y += cameraPivotAngleDifference.y
	leftFoot.desired_angle.y += cameraPivotAngleDifference.y
	rightFoot.desired_angle.y += cameraPivotAngleDifference.y
	
	#leftArm.desired_angle.y += cameraPivotAngleDifference.y
	#rightArm.desired_angle.y += cameraPivotAngleDifference.y
	#leftHandEnd.desired_angle.y += cameraPivotAngleDifference.y
	#rightHandEnd.desired_angle.y += cameraPivotAngleDifference.y
	
	previousCameraPivotAngle = cameraPivot.rotation
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		cameraPivot.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		cameraPivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		cameraPivot.rotation_degrees.x = clamp(cameraPivot.rotation_degrees.x, -90, 90)

func handleWalk():
	isWalking = false
	movingDirection = Vector2(0,0)
	
	#body.rotation.z = 0
	if Input.is_action_pressed("KEY_W"):
		movingDirection.x += 1
		#torsoEnd.desired_angle.z = -PI / 4
		body.apply_central_impulse(-body.transform.basis.y*walkForce)
		isWalking = true
		
	if Input.is_action_pressed("KEY_A"):
		movingDirection.y -= 1
		body.apply_central_impulse(-body.transform.basis.z*walkForce * 10)
		isWalking = true
		
	if Input.is_action_pressed("KEY_D"):
		movingDirection.y += 1
		body.apply_central_impulse(body.transform.basis.z*walkForce * 10)
		isWalking = true
		
	if Input.is_action_pressed("KEY_S"):
		movingDirection.x -= 1
		body.apply_central_impulse(body.transform.basis.y*walkForce)
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
		torsoEnd.desired_angle = torsoEndDesiredAngle 
		#leftLeg.rotation.z = 0
		#rightLeg.rotation.z = 0
		
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
	
	cameraPivot.global_transform.origin = head.global_transform.origin
	handleRotation()
	handleWalk()
	
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
