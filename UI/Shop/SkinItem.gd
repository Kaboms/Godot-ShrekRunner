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
	sdk.connect("SkinPurchaseFailed", self, "OnSkinPurchaseFailed")


func SetSkin(skin: OutdoorSkin):
	ItemOutdoorSkin = skin

	$VBoxContainer/SkinPreview.texture = skin.SkinPreview
	UpdateLabel()

func UpdateLabel():
	# I don't know why, but tr() for translation does not update label at browser. Standalone game works perfectly
	# So I'm forced to use several labels
	if ItemOutdoorSkin.Purchased:
		$VBoxContainer/TextureButton/Use.show()
		
		$VBoxContainer/TextureButton/Price.hide()
		$VBoxContainer/TextureButton/Free.hide()
		$VBoxContainer/TextureButton/Adv.hide()
		return

	if ItemOutdoorSkin.ForAdversation:
		$VBoxContainer/TextureButton/Adv.show()
		
		$VBoxContainer/TextureButton/Use.hide()
		$VBoxContainer/TextureButton/Price.hide()
		$VBoxContainer/TextureButton/Free.hide()
		return
	
	if (ItemOutdoorSkin.Price > 0):
		$VBoxContainer/TextureButton/Price.show()
		$VBoxContainer/TextureButton/Price.set_text(str(ItemOutdoorSkin.Price))
		
		$VBoxContainer/TextureButton/Adv.hide()
		$VBoxContainer/TextureButton/Free.hide()
		$VBoxContainer/TextureButton/Use.hide()
	else:
		$VBoxContainer/TextureButton/Free.show()
		
		$VBoxContainer/TextureButton/Adv.hide()
		$VBoxContainer/TextureButton/Use.hide()
		$VBoxContainer/TextureButton/Price.hide()


func _on_TextureButton_pressed():
	if ItemOutdoorSkin.Purchased:
		StaticSDK.GetSDK().SetSkin(ItemOutdoorSkin.ID)
		return

	if ItemOutdoorSkin.ForAdversation:
		ShowBlocker()
		StaticSDK.GetSDK().ShowSkinRewardedVideo(ItemOutdoorSkin.ID)
		return

	if StaticSDK.GetSDK().Money >= ItemOutdoorSkin.Price:
		ShowBlocker()
		sdk.TryBuySkin(ItemOutdoorSkin)
		return

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

func OnSkinPurchaseFailed(skinId):
	if skinId != ItemOutdoorSkin.ID: return

	RemoveBlocker()

func RemoveBlocker():
	if BlockerInstance == null: return

	BlockerInstance.queue_free()
	BlockerInstance = null
	
func ShowBlocker():
	BlockerInstance = Blocker.instance()
	get_tree().root.add_child(BlockerInstance) 
