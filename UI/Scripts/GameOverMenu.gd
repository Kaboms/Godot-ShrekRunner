extends Control

var IsRewarded: bool = false

func _ready():
	StaticSDK.GetSDK().connect("RewardFailed", self, "OnRewardFailed")
	StaticSDK.GetSDK().connect("RewardSuccess", self, "OnRewardSuccess")
	StaticSDK.GetSDK().connect("RewardClosed", self, "OnRewardClosed")

func _on_Shrek_Death():
	show()

func _on_ExitButton_pressed():
	$"../Shrek".Restart()

func _on_ContinueButton_pressed():
	StaticSDK.GetSDK().ShowRewardedVideo()
	
func OnRewardFailed():
	$"../ErrorMessageBox".show()

func OnRewardSuccess():
	IsRewarded = true
	
func OnRewardClosed():
	if IsRewarded:
		$"../Shrek".StandUp()
		$"..".Continue()
		hide()

	IsRewarded = false
