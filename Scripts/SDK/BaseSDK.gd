extends Node

class_name BaseSDK

signal RewardSuccess
signal RewardFailed
signal RewardClosed

func StartGame():
	print("Started with No SDK")

func ShowAdvBanner():
	pass

func ShowRewardedVideo():
	emit_signal("RewardSuccess")
	emit_signal("RewardClosed")
