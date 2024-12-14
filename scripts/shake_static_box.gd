extends StaticBody3D

var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t+=0.1
	rotate_x((sin(t)) * delta)
	rotate_y((2 * cos(t)) * delta)
	rotate_z((3 * sin(t)) * delta)
	if position.distance_to(Vector3.ZERO) < 4:
		var move_y = pow(sin(t)/10,2)
		translate(Vector3(0, move_y, 0))
	else:
		translate(position.direction_to(Vector3.ZERO))
	pass
