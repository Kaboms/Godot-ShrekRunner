extends Control

var SkinDB: SkinDataBase = preload("res://ShopItems/SkinDataBase.tres")

signal Closed

var sdk = StaticSDK.GetSDK()

# Called when the node enters the scene tree for the first time.
func _ready():
	sdk.connect("DataLoaded", self, "OnDataLoaded")

func _on_Button_pressed():
	hide()
	emit_signal("Closed")

func OnDataLoaded():
	for skin in SkinDB.SkinsDict.values():
		var skinItem: SkinItem = preload("res://UI/Shop/SkinItem.tscn").instance()
		if !skin.Purchased:
			skin.Purchased = sdk.PurchasedSkins.has(skin.ID)
		skinItem.SetSkin(skin)
		$VBoxContainer/ScrollContainer/GridContainer.add_child(skinItem)
