extends Node

class_name LevelSequence

export var LevelLenght: float = 0
var OffsetZ: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func RemoveObstacles():
	if has_node("Obstacles"):
		remove_child(get_node("Obstacles"))
		
	if has_node("Coins"):	
		remove_child(get_node("Coins"))
