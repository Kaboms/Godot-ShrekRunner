extends Node

class_name LevelManager

export(Array, Resource) var Levels = []

var SordedByChanceLevels = {}
var ChancesKeys = []

var LastSpawnedLevel = null

var LevelInstances = []

var OffsetZ = 13

var OffsetToUpdate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var LevelsToPlace = Levels.duplicate()
	randomize()
	LevelsToPlace.shuffle()
	
	OffsetToUpdate += OffsetZ
	
	for level in Levels:
		var levelInstance = level.instance()
		var levelsByChance = SordedByChanceLevels.get(levelInstance.SpawnChance, [])
		levelsByChance.append(level)
		SordedByChanceLevels[levelInstance.SpawnChance] = levelsByChance
	
	ChancesKeys = SordedByChanceLevels.keys()
	ChancesKeys.sort()
	
	print(SordedByChanceLevels)
	
	for i in range(4):
		LastSpawnedLevel = LevelsToPlace[i]
		var LevelInstance: LevelSequence = LastSpawnedLevel.instance()
		AddNewLevel(LevelInstance)

	OffsetToUpdate += LevelInstances[0].LevelLenght
	OffsetToUpdate += LevelInstances[1].LevelLenght

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Shrek.transform.origin.z >= OffsetToUpdate:
		LevelInstances[0].queue_free()
		LevelInstances.remove(0)

		OffsetToUpdate += LevelInstances[1].LevelLenght
		randomize()
		var LevelsToSpawn = []
		var chance = randf()
		for key in ChancesKeys:
			if chance <= key:
				LevelsToSpawn = SordedByChanceLevels[key].duplicate()
				break

		if LastSpawnedLevel != null:
			LevelsToSpawn.erase(LastSpawnedLevel)

		LastSpawnedLevel = LevelsToSpawn[randi() % LevelsToSpawn.size()]
		var LevelInstance: LevelSequence = LastSpawnedLevel.instance()
		AddNewLevel(LevelInstance)
		
func AddNewLevel(LevelInstance):
		add_child(LevelInstance)

		LevelInstances.append(LevelInstance)
		
		LevelInstance.transform.origin.z = OffsetZ + LevelInstance.LevelLenght / 2
		LevelInstance.OffsetZ = OffsetZ
		OffsetZ += LevelInstance.LevelLenght

func StartGame():
	$Shrek.StartGame()

func Continue():
	var currentLevel
	for level in LevelInstances:
		if $Shrek.transform.origin.z > level.OffsetZ:
			level.Clear()
			currentLevel = level
			
	$Shrek.StandUp(currentLevel.GetCheckpoint())
