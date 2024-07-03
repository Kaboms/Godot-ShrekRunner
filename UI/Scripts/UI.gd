extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	StaticSDK.GetSDK().connect("BestScoreChanged", self, "OnBestScoreChanged")
	if ProjectSettings.get_setting("global/DebugUI"):
		$ResetButton.show()
		$AddMoney.show()

func Show():
	$".".show()

func _on_StartButton_pressed():
	$".".hide()

func _on_SettingsButton_pressed():
	$SettingsMenu.show()
	$DownPanel.hide()

func _on_OkButton_pressed():
	$SettingsMenu.hide()
	$DownPanel.show()
	StaticSDK.GetSDK().SetData()

func OnBestScoreChanged(newBestScore):
	$VBoxContainer/ScoreCounterContainer/MaxScore.set_text(str(newBestScore))

func _on_ShopButton_pressed():
	$"../Shop".show()
	hide()

func _on_Shop_Closed():
	show()

func _on_Button_pressed():
	StaticSDK.GetSDK().RemoveProgress()

func _on_AddMoney_pressed():
	var sdk = StaticSDK.GetSDK()
	sdk.SaveStats(sdk.BestScore, sdk.Money + 5000)
