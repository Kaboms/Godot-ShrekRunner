extends Control


func _on_ContinueButton_pressed():
	$".".hide()
	$"../GameUI".show()
	get_tree().paused = false

func _on_ExitButton_pressed():
	get_tree().paused = false
	$"../Shrek".EndGame()
