extends BaseSDK

var TabActivatedCallback = JavaScript.create_callback(self, "TabActivated")
var TabDeactivatedCallback = JavaScript.create_callback(self, "TabDeactivated")

var RewardSuccessCallback = JavaScript.create_callback(self, "RewardSuccess")
var RewardFailedCallback = JavaScript.create_callback(self, "RewardFailed")
var RewardClosedCallback = JavaScript.create_callback(self, "RewardClosed")

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

	TranslationServer.set_locale(LangReferences.get(window.ysdk.environment.i18n.lang, 'en'))
	
func TabActivated(args):
	SoundManager.MuteAllSound(false)

func TabDeactivated(args):
	SoundManager.MuteAllSound(true)
	
func StartGame():
	window.initGame()
	
func ShowAdvBanner():
	window.showAdvBanner()

func ShowRewardedVideo():
	window.showRewardedVideo()
	
func RewardSuccess(args):
	emit_signal("RewardSuccess")

func RewardFailed(args):
	emit_signal("RewardFailed")
	
func RewardClosed(args):
	emit_signal("RewardClosed")
