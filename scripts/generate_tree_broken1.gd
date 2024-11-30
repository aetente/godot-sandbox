@tool
extends Node3D

@export var tree_height: float = 10;
@export var tree_depth: int = 3;

@export var branch_divisions: float = 10;
@export var base_sections: int = 10;
@export var baseBrValue: float = 0.3;
@export var seed: int = 264;

var rng = RandomNumberGenerator.new();

func sizedLineUp(tx: float, ty: float, tz: float, size: float, i, is_main: bool):
	var arr: Array = [];
	var xMin: float = 0;
	var xMax: float = branch_divisions;
	var ht: float = 1;
	var angle1_max = 20;
	var angle2_max = 20 if !is_main else 0;
	for t in range(xMin, xMax, ht):
		var angle: float = angle1_max * sin(rng.randf_range(0, 2 * PI));
		var angle2: float = angle2_max * cos(rng.randf_range(0, 2 * PI));
		var branch: float = 5 / (i + 1);
		var newPosX: float = tx + branch * sin(angle) * sin(angle2);
		var newPosY: float = ty + branch * cos(angle);
		var newPosZ: float = tz + branch * sin(angle) * cos(angle2);
		if (t == xMin):
			arr.push_back(TreeBranch.new(tx, ty, tz, size / 20));
		arr.push_back(TreeBranch.new(newPosX, newPosY, newPosZ, size / 20));
		tx = newPosX;
		ty = newPosY;
		tz = newPosZ;
	return arr;

func makeATree(tx: float, ty: float, tz: float, base_sections: int, baseBrValue: float):
	var tree: Array = [];
	var branch_division_position_index: int = 0;
	var treeDepth: float = 3;
	var baseBr: float = fmod(baseBrValue, 1);
	var lineSize: float;
	var branch_division_relative_position: int;
	for i in range(base_sections):
		if (rng.randf() > 0.5 || i == 0):
			branch_division_relative_position = int(floor(tree[0].size() * baseBr)) if i != 0 else 0;
			branch_division_position_index = int(floor(branch_division_relative_position + rng.randf() * ((tree[0].size() - 1) - branch_division_relative_position))) if i != 0 else 0;
			if i != 0 and branch_division_position_index == 0:
				branch_division_position_index = 1;
			tx = tree[0][branch_division_position_index].x / 2 + tree[0][branch_division_position_index - 1].x / 2 if i != 0 else tx;
			ty = tree[0][branch_division_position_index].y / 2 + tree[0][branch_division_position_index - 1].y / 2 if i != 0 else ty;
			tz = tree[0][branch_division_position_index].z / 2 + tree[0][branch_division_position_index - 1].z / 2 if i != 0 else tz;
			if i == 0:
				lineSize = tree_height;
			else:
				lineSize = (float)(base_sections) / (i + 1);
			tree.push_back(sizedLineUp(tx, ty, tz, lineSize, i, true));

	var curTreeLenght: float = tree.size();
	for j in range(tree_depth):
		curTreeLenght = tree.size();
		for i in range(curTreeLenght):
			for k in range(tree_depth):
				if (i == 0):
					branch_division_relative_position = int(floor(tree[0].size()) * baseBr);
					branch_division_position_index = int(floor(branch_division_relative_position + rng.randf() * ((tree[0].size() - 1) - branch_division_relative_position)));
				else:
					branch_division_position_index = int(floor(rng.randf() * (tree[i].size() - 1)) + 1);
				if branch_division_position_index == 0:
					branch_division_position_index = 1;
				tx = tree[i][branch_division_position_index].x / 2 + tree[i][branch_division_position_index - 1].x / 2;
				ty = tree[i][branch_division_position_index].y / 2 + tree[i][branch_division_position_index - 1].y / 2;
				tz = tree[i][branch_division_position_index].z / 2 + tree[i][branch_division_position_index - 1].z / 2;
				lineSize = treeDepth * treeDepth * base_sections / (k + j * curTreeLenght + i * treeDepth + 1);
				tree.push_back(sizedLineUp(tx, ty, tz, lineSize, i, false));
	return tree;

func drawLineUpPos(coords: Array, x: float, y: float, z: float, r: float, lineSize: float, scr: float):
	var lineWidth: float = 1;
	for i in range(1, coords.size()):
		if (coords[i].size == 0):
			lineWidth = 1;
		else:
			lineWidth = lineSize / 50 * coords.size() / (i) / 10;
		var branchStart: Vector3 = Vector3(scr * coords[i - 1].x + x, scr * coords[i - 1].y + y, scr * coords[i - 1].z + z);
		var branchEnd: Vector3 = Vector3(scr * coords[i].x + x, scr * coords[i].y + y, scr * coords[i].z + z);
		var branchPointsDistance: float = branchStart.distance_to(branchEnd);
		var branchSize: Vector3 = Vector3(lineWidth, lineWidth, branchPointsDistance);

		var cube = MeshInstance3D.new();
		cube.mesh = BoxMesh.new();
		cube.scale = branchSize;
		var cubeMaterial = StandardMaterial3D.new();
		cubeMaterial.albedo_color = Color(200,200,200);
		cube.set_surface_override_material(0, cubeMaterial);
		add_child(cube);
		cube.position = branchStart;
		var branchEndFix: Vector3 = branchEnd + transform.origin;
		if (branchEnd.normalized().y > 0.99):
			cube.rotation.x = PI/4;
			cube.look_at(branchEndFix, Vector3(0,0,1))
		else: 	
			cube.look_at(branchEndFix)
		cube.position = Vector3((branchEnd.x + branchStart.x) / 2, (branchEnd.y + branchStart.y) / 2, (branchEnd.z + branchStart.z) / 2);

func drawTree(b: Array, x: float, y: float, z: float):
	var scr: float = -1;
	var lineSize: float = 0.1;
	for i in range(b.size()):
		lineSize = sqrt(-i + b.size()) * 1.5;
		drawLineUpPos(b[i], x, y, z, 0, lineSize, scr);

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = seed;
	var b = makeATree(0.1, 0.1, 0, base_sections, baseBrValue);
	drawTree(b, 0, 0, 0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
