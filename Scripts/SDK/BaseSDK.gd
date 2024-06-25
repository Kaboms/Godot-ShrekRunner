extends Node

class_name BaseSDK

signal RewardSuccess
signal RewardFailed
signal RewardClosed

signal SkinRewardSuccess
signal SkinRewardFailed
signal SkinRewardClosed

signal SkinChanged

signal MoneyChanged
signal BestScoreChanged

var Money: int = 0
var BestScore: int = 0

enum RewardTypes {
	NewLife
}

func StartGame():
	print("Started with No SDK")

func ShowAdvBanner():
	pass

func ShowRewardedVideo(rewardType):
	emit_signal("RewardSuccess", rewardType)
	emit_signal("RewardClosed", rewardType)

func ShowSkinRewardedVideo(skinId):
	emit_signal("SkinRewardSuccess", skinId)
	emit_signal("SkinRewardClosed", skinId)
	
func SetMoney(newMoney):
	Money = newMoney
	emit_signal("MoneyChanged", Money)

func SetBestScore(newBestScore):
	BestScore = newBestScore
	emit_signal("BestScoreChanged", BestScore)

func SaveMoney(newMoney):
	SetMoney(newMoney)
	
func SaveStats(newBestScore, newMoney):
	SetBestScore(newBestScore)
	SetMoney(newMoney)
	
func ChangeSkin(newSkin: OutdoorSkin):
	emit_signal("SkinChanged", newSkin)
