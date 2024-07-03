tool

extends Button

var SoundEnabled = true

export var SoundBusName = ""
var SoundBusIndex = 0

export var SoundOnText = ""
export var SoundOffText = ""

export(Resource) var SoundOnIcon
export(Resource) var SoundOffIcon

func _ready():
	SoundBusIndex = AudioServer.get_bus_index(SoundBusName)
	SoundEnabled =  SoundManager.IsBusMuted(SoundBusIndex)

	OnStateChanged()

	SoundManager.connect("BusMuteChanged", self, "_on_SoundManager_BusMuteChanged")
	
func SetSoundEnabled(Enabled : bool):
	SoundEnabled = Enabled

	OnStateChanged()

	SoundManager.MuteBus(SoundBusIndex, !SoundEnabled)

func OnStateChanged():
	if SoundEnabled:
		$HBoxContainer/Icon.texture = SoundOnIcon
		$HBoxContainer/Label.text = SoundOnText
	else:
		$HBoxContainer/Icon.texture = SoundOffIcon
		$HBoxContainer/Label.text = SoundOffText

func _on_SoundButton_button_down():	
	SetSoundEnabled(!SoundEnabled)

func _on_SoundManager_BusMuteChanged(var BusIdx: int, var IsMute: bool):
	if BusIdx == SoundBusIndex && !SoundEnabled != IsMute:
		SetSoundEnabled(!IsMute)
