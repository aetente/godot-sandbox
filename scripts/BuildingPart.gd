class_name BuildingPart extends Node

var x : float;
var y : float;
var width : float;
var length : float;
var isValid : bool;


func _init(xValue: float, yValue: float, widthValue: float, lengthValue: float, isValidValue: bool):
	x = xValue;
	y = yValue;
	width = widthValue;
	length = lengthValue;
	isValid = isValidValue;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
