extends Node

class_name LevelManager

export(Array, Resource) var Levels = []

var LevelInstances = []

var OffsetZ = 13

var OffsetToUpdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var LevelsToPlace = Levels.duplicate()
	randomize()
	LevelsToPlace.shuffle()
	
	OffsetToUpdate += OffsetZ
	## TODO Will replace to 5 for in 5
	for level in LevelsToPlace:
		var LevelInstance: LevelSequence = level.instance()
		add_child(LevelInstance)
		
		LevelInstances.append(LevelInstance)
		
		LevelInstance.transform.origin.z = OffsetZ + LevelInstance.LevelLenght / 2
		OffsetZ += LevelInstance.LevelLenght

	OffsetToUpdate += LevelInstances[0].LevelLenght
	OffsetToUpdate += LevelInstances[1].LevelLenght

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Shrek.transform.origin.z >= OffsetToUpdate:
		LevelInstances[0].queue_free()
		LevelInstances.remove(0)

		OffsetToUpdate += LevelInstances[1].LevelLenght

		randomize()
		var LevelInstance: LevelSequence = Levels[randi() % Levels.size()].instance()
		add_child(LevelInstance)

		LevelInstances.append(LevelInstance)
		
		LevelInstance.transform.origin.z = OffsetZ + LevelInstance.LevelLenght / 2
		OffsetZ += LevelInstance.LevelLenght

func StartGame():
	$Shrek.StartGame()
