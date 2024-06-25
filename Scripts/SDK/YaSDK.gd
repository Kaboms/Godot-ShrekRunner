extends BaseSDK

var TabActivatedCallback = JavaScript.create_callback(self, "TabActivated")
var TabDeactivatedCallback = JavaScript.create_callback(self, "TabDeactivated")

var RewardSuccessCallback = JavaScript.create_callback(self, "RewardSuccess")
var RewardFailedCallback = JavaScript.create_callback(self, "RewardFailed")
var RewardClosedCallback = JavaScript.create_callback(self, "RewardClosed")

var SkinRewardSuccessCallback = JavaScript.create_callback(self, "OnSkinRewardSuccess")
var SkinRewardFailedCallback = JavaScript.create_callback(self, "OnSkinRewardFailed")
var SkinRewardClosedCallback = JavaScript.create_callback(self, "OnSkinRewardClosed")

var OnLoadScoreCallback = JavaScript.create_callback(self, "OnLoadScore")
var OnLoadMoneyCallback = JavaScript.create_callback(self, "OnLoadMoney")

var window = JavaScript.get_interface("window")

var LangReferences = {
	"be": "ru",
	"kk": "ru",
	"uk": "ru",
	"uz": "ru",
	"ru": "ru",
}

func _ready():
	window.tabActivated = TabActivatedCallback
	window.tabDeactivated = TabDeactivatedCallback
	
	window.rewardSuccess = RewardSuccessCallback
	window.rewardFailed = RewardFailedCallback
	window.rewardClosed = RewardClosedCallback
	
	window.skinRewardSuccess = SkinRewardSuccessCallback
	window.skinRewardFailed = SkinRewardFailedCallback
	window.skinRewardClosed = SkinRewardClosedCallback
	
	window.onLoadScoreCallback = OnLoadScoreCallback
	window.onLoadMoneyCallback = OnLoadMoneyCallback

	TranslationServer.set_locale(LangReferences.get(window.ysdk.environment.i18n.lang, 'en'))
	
func TabActivated(args):
	SoundManager.MuteAllSound(false)

func TabDeactivated(args):
	SoundManager.MuteAllSound(true)
	
func StartGame():
	window.initGame()
	
func ShowAdvBanner():
	window.showAdvBanner()

func ShowRewardedVideo(rewardType):
	window.showRewardedVideo(rewardType)

func ShowSkinRewardedVideo(skinId):
	window.showSkinRewardedVideo(skinId)
		
func RewardSuccess(args):
	emit_signal("RewardSuccess", args[0])

func RewardFailed(args):
	emit_signal("RewardFailed", args[0])
	
func RewardClosed(args):
	emit_signal("RewardClosed", args[0])

func OnSkinRewardSuccess(args):
	emit_signal("SkinRewardSuccess", args[0])

func OnSkinRewardFailed(args):
	emit_signal("SkinRewardFailed", args[0])
	
func OnSkinRewardClosed(args):
	emit_signal("SkinRewardClosed", args[0])
	
func OnLoadMoney(args):
	print("OnLoadMoney " + str(args))
	SetMoney(args[0])
	
func OnLoadScore(args):
	print("OnLoadScore " + str(args))
	SetBestScore(args[0])

func SaveMoney(newMoney):
	window.saveMoney(newMoney)
	SetMoney(newMoney)
	
func SaveStats(newBestScore, newMoney):
	window.saveStats(newBestScore, newMoney)
	SetBestScore(newBestScore)
	SetMoney(newMoney)
