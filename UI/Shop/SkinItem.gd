extends Control

class_name SkinItem

var ItemOutdoorSkin: OutdoorSkin

var Rewarded = false

func _ready():
	var sdk = StaticSDK.GetSDK()
	sdk.connect("SkinRewardSuccess", self, "SkinRewardSuccess")
	sdk.connect("SkinRewardFailed", self, "SkinRewardFailed")
	sdk.connect("SkinRewardClosed", self, "SkinRewardClosed")

func SetSkin(skin: OutdoorSkin):
	ItemOutdoorSkin = skin

	$VBoxContainer/SkinPreview.texture = skin.SkinPreview
	UpdateLabel()

func UpdateLabel():
	$VBoxContainer/TextureButton/Adv.hide()
	$VBoxContainer/TextureButton/Price.show()
	
	if ItemOutdoorSkin.Purchased:
		$VBoxContainer/TextureButton/Price.set_text(tr("USE"))
		return

	if ItemOutdoorSkin.ForAdversation:
		$VBoxContainer/TextureButton/Adv.show()
		$VBoxContainer/TextureButton/Price.hide()
		return

	if (ItemOutdoorSkin.Price > 0):
		$VBoxContainer/TextureButton/Price.set_text(str(ItemOutdoorSkin.Price))
	else:
		$VBoxContainer/TextureButton/Price.set_text(tr("FREE"))


func _on_TextureButton_pressed():
	if ItemOutdoorSkin.Purchased:
		StaticSDK.GetSDK().ChangeSkin(ItemOutdoorSkin)

	if ItemOutdoorSkin.ForAdversation:
		StaticSDK.GetSDK().ShowSkinRewardedVideo(ItemOutdoorSkin.ID)
		
func SkinRewardSuccess(skinId):
	Rewarded = skinId == ItemOutdoorSkin.ID

func SkinRewardClosed(skinId):
	if Rewarded:
		ItemOutdoorSkin.Purchased = true
		UpdateLabel()
	Rewarded = false

func SkinRewardFailed():
	pass
