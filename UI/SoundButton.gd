tool

extends Button

var SoundEnabled = true

export var SoundBusIndex = ""

export var SoundOnText = ""
export var SoundOffText = ""

export(Resource) var SoundOnIcon
export(Resource) var SoundOffIcon

func _ready():
	SetSoundEnabled(true)

func SetSoundEnabled(Enabled : bool):
	SoundEnabled = Enabled

	var bus_idx = AudioServer.get_bus_index(SoundBusIndex)

	if SoundEnabled:
		$HBoxContainer/Icon.texture = SoundOnIcon
		$HBoxContainer/Label.text = tr(SoundOnText)
	else:
		$HBoxContainer/Icon.texture = SoundOffIcon
		$HBoxContainer/Label.text = tr(SoundOffText)

	AudioServer.set_bus_mute(bus_idx, !SoundEnabled)

func _on_SoundButton_button_down():	
	SetSoundEnabled(!SoundEnabled)

