tool

extends Node

export(Resource) var SpatialToSpawn
export(float) var SpawnChance = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if SpatialToSpawn == null: return

	randomize()
	if Engine.editor_hint || randf() < SpawnChance:
		add_child(SpatialToSpawn.instance())
