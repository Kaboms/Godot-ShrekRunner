extends Control

export(Array, Texture) var Skins = []

signal Closed

# Called when the node enters the scene tree for the first time.
func _ready():
	for skin in Skins:
		var skinItem: SkinItem = preload("res://UI/Shop/SkinItem.tscn").instance()
		skinItem.SetSkin(skin)
		$VBoxContainer/ScrollContainer/GridContainer.add_child(skinItem)

func _on_Button_pressed():
	hide()
	emit_signal("Closed")
