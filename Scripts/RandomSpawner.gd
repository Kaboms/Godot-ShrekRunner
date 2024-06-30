tool

extends Node

export(Array, Resource) var SpatialsToSpawn = []
export(float) var SpawnChance = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if SpatialsToSpawn.empty(): return

	randomize()
	if Engine.editor_hint || randf() < SpawnChance:
		add_child(SpatialsToSpawn[randi() % SpatialsToSpawn.size()].instance())
