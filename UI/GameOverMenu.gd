extends Control

func _ready():
	StaticSDK.GetSDK().connect("RewardFailed", self, "OnRewardFailed")
	StaticSDK.GetSDK().connect("RewardSuccess", self, "OnRewardSuccess")

func _on_Shrek_Death():
	show()

func _on_ExitButton_pressed():
	$"../Shrek".Restart()

func _on_ContinueButton_pressed():
	StaticSDK.GetSDK().ShowRewardedVideo()
	
func OnRewardFailed():
	_on_ExitButton_pressed()

func OnRewardSuccess():
	$"../Shrek".StandUp()
	$"..".Continue()
	hide()
