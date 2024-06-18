extends Node

var CurrentSDK: BaseSDK = null

func _ready():
	GetSDK().StartGame()

func GetSDK():
	if CurrentSDK != null:
		return CurrentSDK

	if ProjectSettings.get_setting("global/SDK") == "Yandex":
		CurrentSDK = preload("res://Scripts/SDK/YaSDK.tscn").instance()
	else:
		CurrentSDK = preload("res://Scripts/SDK/BaseSDK.tscn").instance()

	add_child(CurrentSDK)
	return CurrentSDK
