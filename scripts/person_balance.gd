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
@onready var leftHandEnd = $"rigids/torsoEnd/torso/leftArm/leftHandEnd"
@onready var rightHandEnd = $"rigids/torsoEnd/torso/rightArm/rightHandEnd"


@onready var leftFootRay = $"rigids/leftFoot/leftFootEnd/leftFootRay"
@onready var rightFootRay = $"rigids/rightFoot/rightFootEnd/rightFootRay"


@onready var cameraPivot = $"CameraPivot"

@export var has_camera = true



var jumpForce = 100
var walkForce = 0.5
var leanForce = 1
var walkAnimationTimer = 0
var walkAnimationSpeed = 0.2
var max_angle_forward = 1.5
var isWalking = false

var leftLegDesiredAngle = Vector3(0,0,0)
var rightLegDesiredAngle = Vector3(0,0,0)
var bodyDesiredAngle = Vector3(0,0,0)
var torsoEndDesiredAngle = Vector3(0,0,0)

var previousCameraPivotAngle = Vector3(0,0,0)
var cameraPivotAngleDifference = Vector3(0,0,0)

var movedRightLeg = false
var movedLeftLeg = false

var movingDirection = Vector2(0,0)

var mouse_sensitivity = 0.3

var canJump = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	leftLegDesiredAngle = leftLeg.desired_angle
	rightLegDesiredAngle = rightLeg.desired_angle
	bodyDesiredAngle = body.desired_angle
	torsoEndDesiredAngle = torsoEnd.desired_angle
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if has_camera:
		previousCameraPivotAngle = cameraPivot.rotation
	time_start = Time.get_unix_time_from_system()
	
func resetValues():
	walkAnimationTimer = 0
	movedRightLeg = false
	movedLeftLeg = false
	movingDirection = Vector2(0,0)
	leftLeg.desired_angle = leftLegDesiredAngle 
	rightLeg.desired_angle = rightLegDesiredAngle
	body.desired_angle = bodyDesiredAngle
	torsoEnd.desired_angle = torsoEndDesiredAngle
	
	
func animateWalk():
	walkAnimationTimer += walkAnimationSpeed
	var actualMovingDirection = 0
	if (movingDirection.y > 0 && movingDirection.x >= 0):
		actualMovingDirection = 1
	elif (movingDirection.y == 0):
		actualMovingDirection = movingDirection.x
	elif (movingDirection.y > 0 && movingDirection.x < 0):
		actualMovingDirection = -1
		
	torsoEnd.desired_angle.z = -abs(movingDirection.x) / 2
	if (sin(walkAnimationTimer) > 0 && !movedRightLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 0.1
		movedRightLeg = true
		movedLeftLeg = false
		leftLeg.desired_angle.z += max_angle_forward * actualMovingDirection
		rightLeg.desired_angle.z = 0 * actualMovingDirection
		#leftLeg.desired_angle.x = 1.5*max_angle_forward * movingDirection.y
		#rightLeg.desired_angle.x = 0 * movingDirection.y
		pass
	elif (sin(walkAnimationTimer) <= 0 && !movedLeftLeg):
		#leftLeg.rotation.z = sin(walkAnimationTimer) * 0.1
		#rightLeg.rotation.z = -sin(walkAnimationTimer) * 1
		movedRightLeg = false
		movedLeftLeg = true
		leftLeg.desired_angle.z = 0 * actualMovingDirection
		rightLeg.desired_angle.z += max_angle_forward * actualMovingDirection
		#leftLeg.desired_angle.x = 0 * movingDirection.y
		#rightLeg.desired_angle.x = 1.5*max_angle_forward * movingDirection.y
		pass
	#leftFoot.position.y += (sin(walkAnimationTimer) + 1) / 20 * 1
	#leftFoot.position.x += (cos(walkAnimationTimer)) / 20 * 1
	#rightFoot.position.y += -(sin(walkAnimationTimer) + 1) / 20 * 1
	#rightFoot.position.x += -(cos(walkAnimationTimer)) / 20 * 1
	
func handleCrouch():
	if Input.is_action_pressed("CTRL"):
		leftLeg.desired_angle.z = PI/2
		rightLeg.desired_angle.z = PI/2
		body.desired_angle.z = -PI/1.5
		isWalking = true
		
func handleJump():
	if Input.is_action_just_pressed("jump"):
		if canJump:
			if rightFootRay.is_colliding() or leftFootRay.is_colliding():
				canJump = false
				body.apply_central_impulse(body.global_transform.basis.y*jumpForce)
				await get_tree().create_timer(0.25).timeout
				canJump = true
	
func handleRotation():
	#torsoEnd.rotation.y = cameraPivot.rotation.y
	if has_camera:
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
	
	if has_camera:
		previousCameraPivotAngle = cameraPivot.rotation
	pass
	
func _input(event):
	if has_camera and event is InputEventMouseMotion:
		cameraPivot.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		cameraPivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		cameraPivot.rotation_degrees.x = clamp(cameraPivot.rotation_degrees.x, -90, 90)

func handleHands():
	leftArm.enable = false
	rightArm.enable = false
	if Input.is_action_pressed("left_mouse"):
		leftArm.enable = true
		
	if Input.is_action_pressed("right_mouse"):
		rightArm.enable = true

func handleWalk():
	isWalking = false
	movingDirection = Vector2(0,0)
	
	#body.rotation.z = 0
	if Input.is_action_pressed("KEY_W"):
		movingDirection.x += 1
		#torsoEnd.desired_angle.z = -PI / 4
		body.apply_central_impulse(body.global_transform.basis.x*walkForce)
		isWalking = true
		
	if Input.is_action_pressed("KEY_A"):
		movingDirection.y = 1
		body.apply_central_impulse(-body.global_transform.basis.z*leanForce)
		isWalking = true
		
	if Input.is_action_pressed("KEY_D"):
		movingDirection.y = 1
		body.apply_central_impulse(body.global_transform.basis.z*leanForce)
		isWalking = true
		
	if Input.is_action_pressed("KEY_S"):
		movingDirection.x -= 1
		body.apply_central_impulse(-body.global_transform.basis.x*walkForce)
		isWalking = true
		
	handleCrouch()
	handleJump()
	handleHands()
	
	if isWalking:
		animateWalk()
		pass
	else:
		resetValues()
		
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
	
	if has_camera:
		cameraPivot.global_transform.origin = head.global_transform.origin
	handleRotation()
	handleWalk()
	
	
#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_E:
#		pass
