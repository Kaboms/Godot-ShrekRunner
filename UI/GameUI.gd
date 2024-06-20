extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Shrek_StartGame():
	$".".show()

func _on_Shrek_Death():
	$PauseButton.hide()

func _on_Shrek_StandUp():
	$PauseButton.show()
