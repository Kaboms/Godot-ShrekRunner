extends Node

class_name BaseSDK

signal RewardSuccess
signal RewardFailed
signal RewardClosed

signal MoneyChanged
signal BestScoreChanged

var Money: int = 0
var BestScore: int = 0

func StartGame():
	print("Started with No SDK")

func ShowAdvBanner():
	pass

func ShowRewardedVideo():
	emit_signal("RewardSuccess")
	emit_signal("RewardClosed")
	
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
