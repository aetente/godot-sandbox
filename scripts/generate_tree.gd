@tool
extends Node3D

var rng = RandomNumberGenerator.new();

func directionFunc(tx: float, ty: float, i: float, r: float):
	return - (pow(fmod(tx, ty), 3)) / 10000;

func calmMovementFunc(tx: float, ty: float, i: float, r: float):
	return 1 / sin(i * 2 * PI * rng.randf());

func crazinessFunc(tx: float, ty: float, i: float, r: float):
	return 1 * (sin(10 * ty * i) - 1);

func freqFunc(tx: float, ty: float, i: float, r: float):
	return 2 * PI + 1 * cos(i + 0.2);

func heightFunc(tx: float, ty: float, i: float, k: float, r: float):
	return 4 / ((i + k) / 4 + 1);

func lengthFunc(tx: float, ty: float, i: float, r: float):
	return 5;

func discretFunc(tx: float, ty: float, i: float, r: float):
	return 1;

func sizedLineUp(tx: float, ty: float, tz: float, r: float, calmMovement: float, craziness: float, freq0: float, height0: float, lines: float, discret: float, direction: float, size: float):
	var arr: Array = [];
	var xMin: float = 0;
	var xMax: float = lines;
	var ht: float = discret;
	for t in range(xMin, xMax, ht):
		var angle: float = sin(t * freq0 + r) * (pow(craziness, t)) / calmMovement + direction;
		var angle2: float = cos(t * freq0 + r) * (pow(craziness, t)) / calmMovement + direction;
		# float angle = Sin(t*freq0+r)*(craziness**((r)*(Sin(t/100)+1)/2))/calmMovement+direction;
		# float angle = t**(t/40)*Sin(r/10+calmMovement)+direction;
		var branch: float = height0 + height0 / 2 * sin(t * 2 * PI / 9 + 8 * sin(r / 6));
		var newPosX: float = tx - branch * sin(angle) * sin(angle2);
		var newPosY: float = ty - branch * cos(angle);
		var newPosZ: float = tz - branch * sin(angle) * cos(angle2);
		if (t == xMin):
			arr.push_back(TreeBranch.new(tx, ty, tz, size / 20));
		arr.push_back(TreeBranch.new(newPosX, newPosY, newPosZ, size / 20));
		tx = newPosX;
		ty = newPosY;
		tz = newPosZ;
	return arr;

func makeATree(tx: float, ty: float, tz: float, qBranch: int, baseBrValue: float):
	var tree: Array = [];
	var length: float = 10;
	var branchSegment: int = 0;
	var r: float = 1;
	var treeDepth: float = 3;
	var baseBr: float = fmod(baseBrValue, 1);
	var calmMovement: float;
	var craziness: float;
	var freq0: float;
	var height0: float;
	var discret: float;
	var direction: float;
	var lineSize: float;
	var baseSegment: int;
	for i in range(qBranch):
		if (rng.randf() > 0.5 || i == 0):
			baseSegment = int(floor(tree[0].size() * baseBr)) if i != 0 else 0;
			branchSegment = int(floor(baseSegment + rng.randf() * ((tree[0].size() - 1) - baseSegment))) if i != 0 else baseSegment;
			tx = tree[0][branchSegment].x / 2 + tree[0][branchSegment - 1].x / 2 if i != 0 else tx;
			ty = tree[0][branchSegment].y / 2 + tree[0][branchSegment - 1].y / 2 if i != 0 else ty;
			tz = tree[0][branchSegment].z / 2 + tree[0][branchSegment - 1].z / 2 if i != 0 else tz;
			direction = directionFunc(tx, ty, i, r);
			calmMovement = calmMovementFunc(tx, ty, i, r);
			craziness = crazinessFunc(tx, ty, i, r);
			freq0 = freqFunc(tx, ty, i, r);
			height0 = heightFunc(tx, ty, i, 0, r);
			length = lengthFunc(tx, ty, i, r);
			discret = discretFunc(tx, ty, i, r);
			lineSize = qBranch / (i + 1);
			tree.push_back(sizedLineUp(tx, ty, tz, r, calmMovement, craziness, freq0, height0, length, discret, direction, lineSize));

	var curTreeLenght: float = tree.size();
	for j in range(treeDepth):
		curTreeLenght = tree.size();
		for i in range(curTreeLenght):
			for k in range(treeDepth):
				if (i == 0):
					baseSegment = int(floor(tree[0].size()) * baseBr);
					branchSegment = int(floor(baseSegment + rng.randf() * ((tree[0].size() - 1) - baseSegment)));
				else:
					branchSegment = int(floor(rng.randf() * (tree[i].size() - 1)) + 1);
				tx = tree[i][branchSegment].x / 2 + tree[i][branchSegment - 1].x / 2;
				ty = tree[i][branchSegment].y / 2 + tree[i][branchSegment - 1].y / 2;
				tz = tree[i][branchSegment].z / 2 + tree[i][branchSegment - 1].z / 2;
				direction = directionFunc(tx, ty, i, r);
				calmMovement = calmMovementFunc(tx, ty, i, r);
				craziness = crazinessFunc(tx, ty, i, r);
				freq0 = freqFunc(tx, ty, i, r);
				height0 = heightFunc(tx, ty, i, k, r);
				length = lengthFunc(tx, ty, i, r);
				discret = discretFunc(tx, ty, i, r);
				lineSize = treeDepth * treeDepth * qBranch / (k + j * curTreeLenght + i * treeDepth + 1);
				tree.push_back(sizedLineUp(tx, ty, tz, r, calmMovement, craziness, freq0, height0, length, discret, direction, lineSize));
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
		cubeMaterial.albedo_color = Color(0,0,0);
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
	var b = makeATree(0.1, 0.1, 0, 3, 0.3);
	drawTree(b, 0, 0, 0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
