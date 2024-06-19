extends Button

func _on_Button_pressed():
	get_tree().paused = true
	$"../../PauseMenu".show()
	$"..".hide()
