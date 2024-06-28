extends Node

class_name LevelSequence

export var LevelLenght: float = 0
var OffsetZ: float = 0

var moveable_obstacles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func Clear():
	if has_node("Obstacles"):
		remove_child(get_node("Obstacles"))
		
	if has_node("Coins"):
		remove_child(get_node("Coins"))

	if has_node("Items"):
		remove_child(get_node("Items"))

func _on_EnterArea_body_entered(body):
	if !(body is Player): return

	if has_node("MoveableObstacles"):
		moveable_obstacles = get_node("MoveableObstacles")

		for child in moveable_obstacles.get_children():
			if !(child is MoveableObstacle): continue
			child.Activated = true
