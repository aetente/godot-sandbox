extends Node3D

var amount_of_bells = 16
var bells_to_stack = 3
var probability_to_ignore_bell = 0.1

@onready var static_body = $StaticBody3D

var c_note = preload("res://assets/audio/tests/c.mp3")
var d_note = preload("res://assets/audio/tests/d.mp3")
var e_note = preload("res://assets/audio/tests/e.mp3")
var f_note = preload("res://assets/audio/tests/f.mp3")
var g_note = preload("res://assets/audio/tests/g.mp3")
var a_note = preload("res://assets/audio/tests/a.mp3")
var b_note = preload("res://assets/audio/tests/b.mp3")

var bell_script = preload("res://scripts/bell_part.gd")

var notes = [c_note, d_note, e_note, f_note, g_note, a_note, b_note]

var previousMousePosition = Vector2(0,0)

var rng = RandomNumberGenerator.new()

func genereate_bell(i, note_number):
	var bell_rigid = RigidBody3D.new();
	bell_rigid.contact_monitor = true
	bell_rigid.max_contacts_reported = 1
	var cube_size = Vector3(
		0.2 + rng.randf() * 0.6,
		0.2 + rng.randf() * 0.6,
		1.0 + rng.randf() * 2.0,
	)
	var cube = MeshInstance3D.new();
	cube.mesh = BoxMesh.new();
	cube.scale = cube_size;
	bell_rigid.add_child(cube);
	var bell_collision = CollisionShape3D.new();
	bell_collision.shape = BoxShape3D.new();
	bell_collision.position = Vector3(0, 0, 0);
	bell_collision.shape.size = cube_size;
	bell_rigid.add_child(bell_collision);
	var audio_streamer = AudioStreamPlayer3D.new();
	audio_streamer.name = "AudioStreamPlayer3D";
	audio_streamer.stream = notes[note_number];
	bell_rigid.add_child(audio_streamer);

	bell_rigid.set_script(bell_script);

	add_child(bell_rigid);
	var bell_percent = float(i)/float(amount_of_bells);
	bell_rigid.position = Vector3(4*sin(bell_percent * 2 * PI), 0, 4*cos(bell_percent * 2 * PI));
	bell_rigid.look_at(static_body.position);
	return bell_rigid

func generate_bells():
	for i in range(amount_of_bells):
		if (rng.randf() > probability_to_ignore_bell):
			var random_note = rng.randi_range(0, notes.size() - 1)
			var generated_bell_rigid = genereate_bell(i, random_note)
			var bell_joint = Generic6DOFJoint3D.new();
			bell_joint.node_a = static_body.get_path();
			bell_joint.node_b = generated_bell_rigid.get_path();
			static_body.add_child(bell_joint);
			# bell_joint.position = Vector3(rng.randf_range(-0.5, 0.5), rng.randf_range(-0.5, 0.5), rng.randf_range(-0.5, 0.5))
			bell_joint.position = static_body.position + Vector3(0, static_body.scale.y / 2, 0)
			# bell_joint.rotation = Vector3(rng.randf_range(-0.5, 0.5), rng.randf_range(-0.5, 0.5), rng.randf_range(-0.5, 0.5))
			# bell_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)
			# bell_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)
			# bell_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)

			bell_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)
			bell_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)
			bell_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_bells()
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		static_body.position += Vector3(event.velocity.x, -event.velocity.y, 0) / 10000
		print("Mouse Motion at: ", event.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
