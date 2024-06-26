extends Control

class_name ItemProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func UpdateProgress(newProgress):
	$HBoxContainer/TextureProgress.value = newProgress
