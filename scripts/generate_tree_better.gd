@tool
extends Node3D

@export var tree_height: float = 3;
@export var tree_depth: int = 3;

@export var base_divisions: int = 10;
@export var branch_divisions: int = 3;
@export var base_sections: int = 10;
@export var brancnes_amount: int = 3;
@export var branch_width: float  = 0.5;
@export var baseBrValue: float = 0.3;
@export var seed: int = 264;

@export var base_angle_1: float = PI/18;
@export var base_angle_2: float = PI/18;

@export var base_angle_multiply = 1;

@export var branch_angle_1: float = PI/5;
@export var branch_angle_2: float = PI/5;

@export var branch_angle_multiply = 0.5;

@export var base_section_height: float = 1;
@export var branch_section_height: float = 1;
@export var branch_start_distance : float = 1;

@export var branch_texture: Texture2D;
@export var leaf_texture: Texture2D;

var branch_texture_value
var leaf_texture_value
var rng = RandomNumberGenerator.new();
var leafs_array: Array = [];

func sizedLineUp(tx: float, ty: float, tz: float, size: float, next_size: float, i, is_main: bool):
	var arr: Array = [];
	var xMin: float = 0;
	var xMax: float = base_divisions if is_main else branch_divisions;
	var ht: float = 1;
	var angle1_max = base_angle_1 if is_main else branch_angle_1;
	var angle2_max = base_angle_2 if is_main else branch_angle_2;
	var max_branch_size = base_section_height if is_main else branch_section_height;
	var next_section_size = next_size if is_main else 0.0;
	# var max_branch_size = size;
	var angle: float = angle1_max * sin(rng.randf_range(0, 2 * PI));
	var angle2: float = angle2_max * cos(rng.randf_range(0, 2 * PI));
	for t in range(xMin, xMax, ht):
		# var angle: float = angle1_max;
		# var angle2: float = angle2_max;
		angle1_max = (angle1_max * base_angle_multiply) if is_main else (angle1_max * branch_angle_multiply);
		angle2_max = (angle2_max * base_angle_multiply) if is_main else (angle2_max * branch_angle_multiply);
		angle += angle1_max * sin(rng.randf_range(0, 2 * PI));
		angle2 += angle2_max * cos(rng.randf_range(0, 2 * PI));
		var branch: float = max_branch_size / (i + 1);
		var newPosX: float = tx + branch * sin(angle) * sin(angle2);
		var newPosY: float = ty - branch * cos(angle);
		var newPosZ: float = tz + branch * sin(angle) * cos(angle2);
		var size_position = t / xMax;
		# var size_position = 1;
		var current_size = size + (next_section_size - size) * size_position;
		# if !is_main:
		# 	print("current_size: ", current_size);
		if (t == xMin):
			arr.push_back(TreeBranch.new(tx, ty, tz, current_size));
		arr.push_back(TreeBranch.new(newPosX, newPosY, newPosZ, current_size));
		tx = newPosX;
		ty = newPosY;
		tz = newPosZ;
	return arr;

func makeATree(tx: float, ty: float, tz: float, baseBrValue: float):
	var tree: Array = [];
	var branch_division_position_index: int = 0;
	var treeDepth: float = 3;
	var baseBr: float = fmod(baseBrValue, 1);
	var lineSize: float;
	var branch_division_relative_position: int;
	var main_tree = []
	for i in range(base_sections):
		# branch_division_relative_position = int(floor(tree[0].size() * baseBr)) if i != 0 else 0;
		# branch_division_position_index = int(floor(branch_division_relative_position + rng.randf() * ((tree[0].size() - 1) - branch_division_relative_position))) if i != 0 else 0;
		branch_division_position_index = i if i!= 0 else 0;
		var last_branch_section_index = 0
		if i != 0:
			last_branch_section_index = main_tree[branch_division_position_index - 1].size() - 1
		tx = main_tree[branch_division_position_index - 1][last_branch_section_index].x if i != 0 else tx;
		ty = main_tree[branch_division_position_index - 1][last_branch_section_index].y if i != 0 else ty;
		tz = main_tree[branch_division_position_index - 1][last_branch_section_index].z if i != 0 else tz;
		# if i == 0:
		# 	lineSize = tree_height;
		# else:
		lineSize = (float)(branch_width) / (i * 4 + 1);
		var nextLineSize = (float)(branch_width) / ((i + 1) * 4 + 1);
		# print("main lineSize: ", lineSize);
		# lineSize = 1;
		main_tree.push_back(sizedLineUp(tx, ty, tz, lineSize, nextLineSize, i, true));

	tree = main_tree;	

	var curTreeLenght: float = tree.size();
	for j in range(tree_depth):
		curTreeLenght = tree.size();
		for i in range(curTreeLenght):
			for k in range(brancnes_amount):
				# if (i == 0):
				branch_division_relative_position = int(floor(tree[i].size()) * baseBr);
				branch_division_position_index = int(floor(branch_division_relative_position + rng.randf() * ((tree[i].size() - 1) - branch_division_relative_position)));
				# else:
				# 	branch_division_position_index = int(floor(rng.randf() * (tree[i].size() - 1)) + 1);
				if branch_division_position_index == 0:
					branch_division_position_index = 1;

				
				var tree1_pos = Vector3(tree[i][branch_division_position_index].x, tree[i][branch_division_position_index].y, tree[i][branch_division_position_index].z);
				var tree2_pos = Vector3(tree[0][0].x, tree[0][0].y, tree[0][0].z);
				var dist_to_zero = tree1_pos.distance_to(tree2_pos);
				
				if (rng.randf() > 0.1 and dist_to_zero >= branch_start_distance):
					tx = tree[i][branch_division_position_index].x / 2 + tree[i][branch_division_position_index - 1].x / 2;
					ty = tree[i][branch_division_position_index].y / 2 + tree[i][branch_division_position_index - 1].y / 2;
					tz = tree[i][branch_division_position_index].z / 2 + tree[i][branch_division_position_index - 1].z / 2;
					#lineSize = treeDepth * treeDepth * branch_width / (k + j * curTreeLenght + i * treeDepth + 1);
					# lineSize = (float)(branch_width) / (k + j * curTreeLenght + i * treeDepth + 1) / 2;
					
					# lineSize = (float)(branch_width) / (k + i * treeDepth + 1) / 2;
					lineSize = (float)(tree[i][branch_division_position_index].size) / (k * 20 + 1);
					var nextLineSize = (float)(tree[i][branch_division_position_index].size) / ((k + 1) * 20 + 1);
					# lineSize = (float)(tree[i][branch_division_position_index].size)
					# print("base lineSize: ", lineSize);
					# print("branch lineSize: ", lineSize);
					var branches_array = sizedLineUp(tx, ty, tz, lineSize, nextLineSize, 0, false);
					for l in range(1, branches_array.size()):
						var branch_el = branches_array[l];
						var branch_el_previous = branches_array[l - 1];
						# why is it minus?
						var branch_el_position = Vector3(-branch_el.x, -branch_el.y, -branch_el.z);
						var branch_el_previous_position = Vector3(-branch_el_previous.x, -branch_el_previous.y, -branch_el_previous.z);
						var angle_between = branch_el_previous_position.angle_to(branch_el_position);
						leafs_array.push_back([branch_el_position, branch_el_previous_position]);
					tree.push_back(branches_array);
	return tree;

func drawLineUpPos(coords: Array, x: float, y: float, z: float, r: float, scr: float):
	var lineWidth: float = 1;
	# for i in range(0, coords.size()):
	for i in range(1, coords.size()):
		if (coords[i].size == 0):
			lineWidth = 0.1;
		else:
			# lineWidth = lineSize / 50 * coords.size() / (i) / 10;
			lineWidth = coords[i-1].size;
		var branchStart: Vector3 = Vector3(scr * coords[i - 1].x + x, scr * coords[i - 1].y + y, scr * coords[i - 1].z + z);
		var branchEnd: Vector3 = Vector3(scr * coords[i].x + x, scr * coords[i].y + y, scr * coords[i].z + z);
		var branchPointsDistance: float = branchStart.distance_to(branchEnd);
		var branchSize: Vector3 = Vector3(lineWidth, lineWidth, branchPointsDistance);
		# print("branchSize: ", branchSize);

		var cube = MeshInstance3D.new();
		cube.mesh = BoxMesh.new();
		cube.scale = branchSize;
		var cubeMaterial = StandardMaterial3D.new();

		if branch_texture_value:
			cubeMaterial.albedo_texture = branch_texture;
		else:
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

	for i in range(0, leafs_array.size()):
		var rotationPivot = Node3D.new();
		add_child(rotationPivot);
		var leaf = MeshInstance3D.new();
		leaf.mesh = PlaneMesh.new();
		leaf.scale = Vector3(1, 1, 1);
		var leafMaterial = StandardMaterial3D.new();
	
		if leaf_texture_value:
			leafMaterial.albedo_texture = leaf_texture;
		else:
			leafMaterial.albedo_color = Color(100,200,100);
		
		leafMaterial.cull_mode = BaseMaterial3D.CULL_DISABLED;
		leafMaterial.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA;
		
		leaf.set_surface_override_material(0, leafMaterial);
		rotationPivot.add_child(leaf);
		rotationPivot.position = leafs_array[i][0];
		leaf.position = Vector3(0, 0, -1);
		# leaf.rotation.y = leafs_array[i][1];
		# leaf.look_at(leafs_array[i][1], Vector3(1,0,0))
		# leaf.look_at(leafs_array[i][0] + (leafs_array[i][0] - leafs_array[i][1]) * 200, Vector3(0,0,1))
		# roationPivot.look_at(leafs_array[i][0] + (leafs_array[i][0] - leafs_array[i][1]) * 200, Vector3(0,0,1))
		# rotationPivot.rotate(Vector3.UP, -PI/2);
		rotationPivot.look_at(leafs_array[i][0] + (leafs_array[i][0] - leafs_array[i][1]) * 200, Vector3(0,0,1))
		rotationPivot.rotate(Vector3.UP, PI/4 * rng.randf_range(-1, 1));
		rotationPivot.rotate(Vector3.RIGHT, PI/4 * rng.randf_range(-1, 1));
		rotationPivot.rotate(Vector3.BACK, PI/4 * rng.randf_range(-1, 1));


func drawTree(b: Array, x: float, y: float, z: float):
	var scr: float = -1;
	for i in range(b.size()):
		drawLineUpPos(b[i], x, y, z, 0, scr);

# Called when the node enters the scene tree for the first time.
func _ready():
	# print("==============")
	if branch_texture:
		branch_texture_value = load(branch_texture.resource_path);
	
	if leaf_texture:
		leaf_texture_value = load(leaf_texture.resource_path);
	rng.seed = seed;
	var b = makeATree(0.1, 0.1, 0, baseBrValue);
	drawTree(b, 0, 0, 0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
