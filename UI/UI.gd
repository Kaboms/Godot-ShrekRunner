extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Show():
	$".".show()
	yield(get_tree().create_timer(0.25), "timeout")
	$StartGameButton.disabled = false

func _on_StartGameButton_button_down():
	$".".hide()
	$StartGameButton.disabled = true
