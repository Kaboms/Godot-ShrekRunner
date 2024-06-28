extends Control

class_name SkinItem

var ItemOutdoorSkin: OutdoorSkin

var Rewarded = false

var sdk: BaseSDK

var Blocker = preload("res://UI/Blocker.tscn")
var BlockerInstance = null

func _ready():
	sdk = StaticSDK.GetSDK()
	sdk.connect("SkinRewardSuccess", self, "SkinRewardSuccess")
	sdk.connect("SkinRewardFailed", self, "SkinRewardFailed")
	sdk.connect("SkinRewardClosed", self, "SkinRewardClosed")

	sdk.connect("SkinPurchased", self, "OnSkinPurchased")


func SetSkin(skin: OutdoorSkin):
	ItemOutdoorSkin = skin

	$VBoxContainer/SkinPreview.texture = skin.SkinPreview
	UpdateLabel()

func UpdateLabel():
	$VBoxContainer/TextureButton/Adv.hide()
	$VBoxContainer/TextureButton/Price.show()
	
	if ItemOutdoorSkin.Purchased:
		$VBoxContainer/TextureButton/Price.set_text(tr("Use"))
		return

	if ItemOutdoorSkin.ForAdversation:
		$VBoxContainer/TextureButton/Adv.show()
		$VBoxContainer/TextureButton/Price.hide()
		return

	if (ItemOutdoorSkin.Price > 0):
		$VBoxContainer/TextureButton/Price.set_text(str(ItemOutdoorSkin.Price))
	else:
		$VBoxContainer/TextureButton/Price.set_text(tr("Free"))


func _on_TextureButton_pressed():
	if StaticSDK.GetSDK().Money < ItemOutdoorSkin.Price: return

	if ItemOutdoorSkin.Purchased:
		StaticSDK.GetSDK().SetSkin(ItemOutdoorSkin.ID)
		return

	BlockerInstance = Blocker.instance()
	get_tree().root.add_child(BlockerInstance) 
	if ItemOutdoorSkin.ForAdversation:
		StaticSDK.GetSDK().ShowSkinRewardedVideo(ItemOutdoorSkin.ID)
		return

	sdk.TryBuySkin(ItemOutdoorSkin)

func SkinRewardSuccess(skinId):
	Rewarded = skinId == ItemOutdoorSkin.ID

func SkinRewardClosed(skinId):
	if skinId != ItemOutdoorSkin.ID: return

	if Rewarded:
		ItemOutdoorSkin.Purchased = true
		UpdateLabel()

	RemoveBlocker()

	Rewarded = false

func SkinRewardFailed(skinId):
	if skinId != ItemOutdoorSkin.ID: return

func OnSkinPurchased(skinId):
	if skinId != ItemOutdoorSkin.ID: return

	RemoveBlocker()

	ItemOutdoorSkin.Purchased = true
	UpdateLabel()
	
func RemoveBlocker():
	if BlockerInstance == null: return

	BlockerInstance.queue_free()
	BlockerInstance = null
