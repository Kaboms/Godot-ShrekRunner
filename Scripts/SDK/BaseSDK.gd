extends Node

class_name BaseSDK

signal RewardSuccess
signal RewardFailed
signal RewardClosed

signal SkinRewardSuccess
signal SkinRewardFailed
signal SkinRewardClosed

signal SkinPurchased

signal SkinChanged

signal MoneyChanged
signal BestScoreChanged

signal DataLoaded

var Money: int = 0
var BestScore: int = 0

var PurchasedSkins = []

enum RewardTypes {
	NewLife
}

var SkinDB: SkinDataBase = preload("res://ShopItems/SkinDataBase.tres")

func StartGame():
	print("Started with No SDK")
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("DataLoaded")

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
	
func TryBuySkin(skin: OutdoorSkin):
	emit_signal("SkinPurchased", skin.ID)

func RemoveProgress():
	pass
