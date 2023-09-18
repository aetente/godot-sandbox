@tool
extends Node

@export var areaSize: Vector2 = Vector2(50, 50);
@export var buidlingMinHeight: float = 5;
@export var floors: int = 5;
@export var cellsPerRow: float = 10;
@export var texuresAmount: int = 4;
var m_MainTexture: Texture2D;
var rng = RandomNumberGenerator.new();

var BuildingPart = load("res://scripts/BuildingPart.gd");

func GenerateCellsPositions(maxDistance: float = 0):
	var arr: Array = [];
	var minCellSize: float = maxDistance / cellsPerRow;
	var cellSizeDiff: float = minCellSize / 1.2;

	var currentCellSize: float = minCellSize + rng.randf_range(-1.0, 1.0) * cellSizeDiff;
	var currentPosition: float = 0;
	var cellEnd: float = currentPosition + currentCellSize;
	while (cellEnd < maxDistance):
		arr.push_back(currentPosition);
		currentPosition = cellEnd;
		currentCellSize = minCellSize + rng.randf_range(-1.0, 1.0) * cellSizeDiff;
		cellEnd += currentCellSize;
	return arr;

func GenerateBuildingParts(rows: Array, columns: Array):
	var buildingFloors: Array = [];
	var arr: Array = [];
	var buildingPartsRow: Array = [];
	for floor in range(floors):
		for i in range(1, columns.size()):
			for j in range(1, rows.size()):
				var b: BuildingPart;
				if (rng.randf() > 0.3):
					var x: float = columns[i - 1];
					var y: float = rows[j - 1];
					var width: float = columns[i] - x;
					var length: float = rows[j] - y;
					b = BuildingPart.new(x, y, width, length, true);
				else:
					b = BuildingPart.new(0, 0, 0, 0, false);

				buildingPartsRow.push_back(b);

			arr.push_back(buildingPartsRow);
			buildingPartsRow = [];

		buildingFloors.push_back(arr);
		arr = [];

	for floor in range(buildingFloors.size()):
		for i in range(buildingFloors[floor].size()):
			for j in range(buildingFloors[floor][i].size()):
				if (buildingFloors[floor][i][j].isValid):
					if (
						(i == 0 || ! buildingFloors[floor][i - 1][j].isValid) &&
						(j == 0 || ! buildingFloors[floor][i][j - 1].isValid) &&
						(i == buildingFloors[floor].size() - 1 || ! buildingFloors[floor][i + 1][j].isValid) &&
						(j == buildingFloors[floor][i].size() - 1 || ! buildingFloors[floor][i][j + 1].isValid)
					):
						buildingFloors[floor][i][j].isValid = false;
					else:
						var cube = MeshInstance3D.new();
						cube.mesh = BoxMesh.new();
						cube.scale = Vector3(buildingFloors[floor][i][j].width, buidlingMinHeight, buildingFloors[floor][i][j].length);
						cube.position = Vector3(
							buildingFloors[floor][i][j].x + buildingFloors[floor][i][j].width / 2,
							buidlingMinHeight / 2 * (2 * floor + 1),
							buildingFloors[floor][i][j].y + buildingFloors[floor][i][j].length / 2
						);
						var cubeMaterial = StandardMaterial3D.new();
						var textureIndex: int = int(round(rng.randf() * (texuresAmount - 1)));
						cubeMaterial.albedo_texture = load("res://assets/generated_building/wall/brick_wall" + str(textureIndex) + ".png");
						#var uv_scale : Vector3 = Vector3(buildingFloors[floor][i][j].width, buidlingMinHeight, buildingFloors[floor][i][j].length);
						var biggerSide: float = buildingFloors[floor][i][j].width;
						if (buildingFloors[floor][i][j].width < buildingFloors[floor][i][j].length):
							biggerSide = buildingFloors[floor][i][j].length;
						var uv_scale: Vector3 = Vector3(
							2*biggerSide / buidlingMinHeight,
							2*buidlingMinHeight / buidlingMinHeight,
							1
							);
						cubeMaterial.uv1_scale = uv_scale;
						cubeMaterial.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS;
						cube.set_surface_override_material(0, cubeMaterial);
						add_child(cube);

						# cube.GetComponent < Renderer > ().material.color = Color.white;

						#
						# m_MainTexture = Resources.Load < Texture2D > ("generated_building/wall/brick_wall" + textureIndex);

						# cube.GetComponent < Renderer > ().material.SetTexture("_MainTex", m_MainTexture);


						var roof = MeshInstance3D.new();
						roof.mesh = BoxMesh.new();
						roof.scale = Vector3(buildingFloors[floor][i][j].width + 0.5, 0.5, buildingFloors[floor][i][j].length + 0.5);
						roof.position = Vector3(
							buildingFloors[floor][i][j].x + buildingFloors[floor][i][j].width / 2,
							buidlingMinHeight * (floor + 1),
							buildingFloors[floor][i][j].y + buildingFloors[floor][i][j].length / 2
						);
						add_child(roof);
						# roof.GetComponent < Renderer > ().material.color = Color.white;

	return buildingFloors;


# Called when the node enters the scene tree for the first time.
func _ready():
	var columnsPositions: Array = GenerateCellsPositions(areaSize.x);
	var rowsPositions: Array = GenerateCellsPositions(areaSize.y);
	GenerateBuildingParts(rowsPositions, columnsPositions);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass
