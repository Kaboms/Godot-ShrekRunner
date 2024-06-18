extends BaseSDK

var window = JavaScript.get_interface("window")

func StartGame():
	window.initGame()
