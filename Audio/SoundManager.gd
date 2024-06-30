extends Node

signal BusMuteChanged(BusIdx, IsMute)

var IsMasterMuted = false

func MuteBusByName(BusName, IsMute: bool):
	var soundBusIndex = AudioServer.get_bus_index(BusName)
	MuteBus(soundBusIndex, IsMute)


func MuteBus(BusIdx: int, IsMute: bool):
	AudioServer.set_bus_mute(BusIdx, IsMute)
	emit_signal("BusMuteChanged", BusIdx, IsMute)

func MuteAllSound(IsMute: bool):
	var MasterIndex = AudioServer.get_bus_index("Master")
	
	if IsMute:
		IsMasterMuted = AudioServer.is_bus_mute(MasterIndex)
		AudioServer.set_bus_mute(MasterIndex, true)
	elif !IsMute && !IsMasterMuted:
		AudioServer.set_bus_mute(MasterIndex, false)
