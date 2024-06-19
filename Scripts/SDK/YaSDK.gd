extends BaseSDK

var TabActivatedCallback = JavaScript.create_callback(self, "TabActivated")
var TabDeactivatedallback = JavaScript.create_callback(self, "TabDeactivated")

var window = JavaScript.get_interface("window")

func _ready():
	print("XYU")
	window.tabActivated = TabActivatedCallback
	window.tabDeactivated = TabDeactivatedallback

func TabActivated(args):
	SoundManager.MuteAllSound(false)

func TabDeactivated(args):
	SoundManager.MuteAllSound(true)
	
func StartGame():
	window.initGame()
	
func ShowAdvBanner():
	window.showAdvBanner()
