tool
extends Node

var Obctacles = [
	 preload("res://Obstacles/Beanstlk.tscn")
]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Obctacles[randi() % Obctacles.size()].instance())
