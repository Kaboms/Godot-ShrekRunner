extends Control

var IsRewarded: bool = false

func _ready():
	StaticSDK.GetSDK().connect("RewardFailed", self, "OnRewardFailed")
	StaticSDK.GetSDK().connect("RewardSuccess", self, "OnRewardSuccess")
	StaticSDK.GetSDK().connect("RewardClosed", self, "OnRewardClosed")

func _on_Shrek_Death():
	show()

func _on_ExitButton_pressed():
	$"../Shrek".EndGame()

func _on_ContinueButton_pressed():
	StaticSDK.GetSDK().ShowRewardedVideo(BaseSDK.RewardTypes.NewLife)
	
func OnRewardFailed():
	$"../ErrorMessageBox".show()

func OnRewardSuccess(rewardType):
	IsRewarded = rewardType == BaseSDK.RewardTypes.NewLife

func OnRewardClosed(rewardType):
	if rewardType != BaseSDK.RewardTypes.NewLife: return
	
	if IsRewarded:
		$"..".Continue()
		hide()

	IsRewarded = false
