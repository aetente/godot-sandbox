extends Skeleton3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var FLAG_ENABLE_MOTOR = 4
var FLAG_ENABLE_ANGULAR_LIMIT = 1
var F = 340

var time_start = 0
var time_now = 0

@onready var body = $"torsoEnd/body"
@onready var head = $"head"
@onready var torsoEnd = $"torsoEnd"

@onready var leftFoot = $"leftFoot"
@onready var rightFoot = $"rightFoot"
@onready var leftLeg = $"leftLeg"
@onready var rightLeg = $"rightLeg"

@onready var leftArm = $"torsoEnd/body/leftArm"
@onready var rightArm = $"torsoEnd/body/rightArm"
@onready var leftHandEnd = $"torsoEnd/body/leftHandEnd"
@onready var rightHandEnd = $"torsoEnd/body/rightHandEnd"


@onready var leftFootRay = $"leftFoot/leftFootRay"
@onready var rightFootRay = $"rightFoot/rightFootRay"


@onready var cameraPivot = $"CameraPivot"

@export var is_bot = true
@export var has_camera = !is_bot and true
# vec3(-1.546, -0.72, -2.615) - vec3(-0.085, -3.132, -0.194) = vec3(-1.461, 2.412, -2.421) 
# vec3(-1.546, 0.72, 2.615) - vec3(-0.008, 3.126, 0.193)

# -1.5, 1, -1
@export var forward_left_leg_angle = Vector3(0,0,1.5)
# -1.5, -1, 1
@export var forward_right_leg_angle = Vector3(0,0,1.5)
@export var leg_go_power = 1.0;


var jumpForce = 100
var walkForce = 0.5
var leanForce = 1
var walkAnimationTimer = 0
var walkAnimationSpeed = 0.2

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

var actionIndex = randi() % 6



# Called when the node enters the scene tree for the first time.
func _ready():
	physical_bones_start_simulation();
	
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
		
	torsoEnd.desired_angle.z = -abs(movingDirection.x) / 2
	if (sin(walkAnimationTimer) > 0 && !movedRightLeg):
		movedRightLeg = true
		movedLeftLeg = false
		leftLeg.desired_angle += (leg_go_power * forward_left_leg_angle)
		rightLeg.desired_angle = rightLegDesiredAngle
		pass
	elif (sin(walkAnimationTimer) <= 0 && !movedLeftLeg):
		movedRightLeg = false
		movedLeftLeg = true
		leftLeg.desired_angle = leftLegDesiredAngle
		rightLeg.desired_angle += (leg_go_power * forward_right_leg_angle)
		pass
	
func handleCrouch():
	if Input.is_action_pressed("CTRL"):
		crouch()
		
func handleJump():
	if Input.is_action_just_pressed("jump"):
		if canJump:
			jump()
	
func handleRotation():
	#torsoEnd.rotation.y = cameraPivot.rotation.y
	if has_camera:
		cameraPivotAngleDifference = cameraPivot.rotation - previousCameraPivotAngle
	elif is_bot:
		var change_angle = randf() > 0.9
		if change_angle:
			cameraPivotAngleDifference = Vector3(0, RandomNumberGenerator.new().randf_range(-PI/10, PI/10), 0)	
	
	leftLegDesiredAngle.y += cameraPivotAngleDifference.y
	rightLegDesiredAngle.y += cameraPivotAngleDifference.y
	torsoEndDesiredAngle.y += cameraPivotAngleDifference.y
	bodyDesiredAngle.y += cameraPivotAngleDifference.y
	
	#base.rotation.y += cameraPivotAngleDifference.y
	#head.desired_angle.y += cameraPivotAngleDifference.y
	
	body.desired_angle.y += cameraPivotAngleDifference.y
	torsoEnd.desired_angle.y += cameraPivotAngleDifference.y
	leftLeg.desired_angle.y += cameraPivotAngleDifference.y
	rightLeg.desired_angle.y += cameraPivotAngleDifference.y
	leftFoot.desired_angle.y += cameraPivotAngleDifference.y
	rightFoot.desired_angle.y += cameraPivotAngleDifference.y
	
	# leftArm.desired_angle.y += cameraPivotAngleDifference.y
	# rightArm.desired_angle.y += cameraPivotAngleDifference.y
	# leftHandEnd.desired_angle.y += cameraPivotAngleDifference.y
	# rightHandEnd.desired_angle.y += cameraPivotAngleDifference.y
	
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

func walkForward():
	movingDirection.x += 1
	#torsoEnd.desired_angle.z = -PI / 4
	body.apply_central_impulse(body.global_transform.basis.z*walkForce)
	isWalking = true

func walkBackward():
	movingDirection.x -= 1
	body.apply_central_impulse(-body.global_transform.basis.z*walkForce)
	isWalking = true

func walkRight():
	movingDirection.y = 1
	body.apply_central_impulse(body.global_transform.basis.x*leanForce)
	isWalking = true

func walkLeft():
	movingDirection.y = 1
	body.apply_central_impulse(-body.global_transform.basis.x*leanForce)
	isWalking = true

func jump():
	if canJump:
		if rightFootRay.is_colliding() or leftFootRay.is_colliding():
			canJump = false
			body.apply_central_impulse(body.global_transform.basis.y*jumpForce)
			await get_tree().create_timer(0.25).timeout
			canJump = true

func crouch():
	leftLeg.desired_angle.z = PI/2
	rightLeg.desired_angle.z = PI/2
	body.desired_angle.z = -PI/1.5
	isWalking = true


func handleWalk():
	isWalking = false
	movingDirection = Vector2(0,0)
	
	if is_bot:
		var is_change_action = randf() > 0.9
		if is_change_action: 
			actionIndex = randi() % 6
		if actionIndex == 0:
			walkForward()
		elif actionIndex == 1:
			walkBackward()
		elif actionIndex == 2:
			walkRight()
		elif actionIndex == 3:
			walkLeft()
		elif actionIndex == 4:
			handleRotation()
		# elif actionIndex == 5:
		# 	jump()

	else:
		#body.rotation.z = 0
		if Input.is_action_pressed("KEY_W"):
			walkForward()
			
		if Input.is_action_pressed("KEY_A"):
			walkLeft()
			
		if Input.is_action_pressed("KEY_D"):
			walkRight()
			
		if Input.is_action_pressed("KEY_S"):
			walkBackward()
			
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
