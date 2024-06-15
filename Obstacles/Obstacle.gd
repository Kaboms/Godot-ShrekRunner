tool
extends Node

export(Array, Resource) var Obctacles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_child(Obctacles[randi() % Obctacles.size()].instance())
