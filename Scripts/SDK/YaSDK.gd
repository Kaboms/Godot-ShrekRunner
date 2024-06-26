extends BaseSDK

var TabActivatedCallback = JavaScript.create_callback(self, "TabActivated")
var TabDeactivatedCallback = JavaScript.create_callback(self, "TabDeactivated")

var RewardSuccessCallback = JavaScript.create_callback(self, "RewardSuccess")
var RewardFailedCallback = JavaScript.create_callback(self, "RewardFailed")
var RewardClosedCallback = JavaScript.create_callback(self, "RewardClosed")

var SkinRewardSuccessCallback = JavaScript.create_callback(self, "OnSkinRewardSuccess")
var SkinRewardFailedCallback = JavaScript.create_callback(self, "OnSkinRewardFailed")
var SkinRewardClosedCallback = JavaScript.create_callback(self, "OnSkinRewardClosed")

var OnBuySkinCallback = JavaScript.create_callback(self, "OnBuySkin")

var OnLoadScoreCallback = JavaScript.create_callback(self, "OnLoadScore")
var OnLoadMoneyCallback = JavaScript.create_callback(self, "OnLoadMoney")
var OnLoadDataCallback = JavaScript.create_callback(self, "OnLoadData")
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
	
	window.onBuySkinCallback = OnBuySkinCallback
	
	window.onLoadScoreCallback = OnLoadScoreCallback
	window.onLoadMoneyCallback = OnLoadMoneyCallback
	window.onLoadDataCallback = OnLoadDataCallback

func TabActivated(args):
	SoundManager.MuteAllSound(false)

func TabDeactivated(args):
	SoundManager.MuteAllSound(true)
	
func StartGame():
	window.initGame()

func ShowAdvBanner():
	window.showAdvBanner()

func ShowRewardedVideo(rewardType):
	SoundManager.MuteAllSound(true)
	window.showRewardedVideo(rewardType)

func ShowSkinRewardedVideo(skinId):
	SoundManager.MuteAllSound(true)
	window.showSkinRewardedVideo(skinId)
		
func RewardSuccess(args):
	emit_signal("RewardSuccess", args[0])

func RewardFailed(args):
	emit_signal("RewardFailed", args[0])
	
func RewardClosed(args):
	SoundManager.MuteAllSound(false)
	emit_signal("RewardClosed", args[0])

func OnSkinRewardSuccess(args):
	var skinId = args[0]
	PurchasedSkins.append(skinId)
	
	var jsSkins = JavaScript.create_object("Array")
	for purchasedSkin in PurchasedSkins:
		jsSkins.push(purchasedSkin)
	
	window.onBuySkin(skinId, jsSkins, Money)
	
	emit_signal("SkinRewardSuccess", args[0])

func OnSkinRewardFailed(args):
	emit_signal("SkinRewardFailed", args[0])
	
func OnSkinRewardClosed(args):
	SoundManager.MuteAllSound(false)
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

func TryBuySkin(skin: OutdoorSkin):
	if Money < skin.Price: return

	SetMoney(Money - skin.Price)
	
	PurchasedSkins.append(skin.ID)
	
	var jsSkins = JavaScript.create_object("Array")
	for purchasedSkin in PurchasedSkins:
		jsSkins.push(purchasedSkin)
	
	window.onBuySkin(skin.ID, jsSkins, Money)

func OnBuySkin(args):
	var skinId = args[0]
	
	emit_signal("SkinPurchased", skinId)

func OnLoadData(args):
	TranslationServer.set_locale(LangReferences.get(window.ysdk.environment.i18n.lang, 'en'))

	if args.size() != 0:
		if args[0].skins:
			PurchasedSkins = []
			for skinIndex in range(0, args[0].skins.length):
				PurchasedSkins.append(args[0].skins[skinIndex])

		if args[0].skinId != null:
			emit_signal("SkinChanged", SkinDB.SkinsDict[args[0].skinId])

	print("DataLoaded")
	emit_signal("DataLoaded")

func RemoveProgress():
	SaveStats(0, 0)

	window.clearSkins()

func ChangeSkin(newSkin: OutdoorSkin):
	window.changeSkin(newSkin.ID)
	emit_signal("SkinChanged", newSkin)
