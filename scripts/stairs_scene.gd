extends Node3D

@onready var camera = get_node('./Camera3D');
@onready var body_torso = get_node('./person/rigids/torso')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position.y = body_torso.position.y + 2
