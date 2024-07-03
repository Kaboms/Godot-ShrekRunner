extends Node

signal BusMuteChanged(BusIdx, IsMute)

var ManualMutedBuses = {}

var MuteAllRequests = 0

func MuteBusByName(BusName, IsMute: bool):
	print("MuteBus " + str(BusName))
	
	var soundBusIndex = AudioServer.get_bus_index(BusName)
	MuteBus(soundBusIndex, IsMute)

func MuteBus(BusIdx: int, IsMute: bool):
	ManualMutedBuses[BusIdx] = IsMute

	print("MuteBus " + str(BusIdx))

	AudioServer.set_bus_mute(BusIdx, IsMute)
	emit_signal("BusMuteChanged", BusIdx, IsMute)

func IsBusMuted(BusIdx):
	return !ManualMutedBuses.get(BusIdx, false)

func MuteAllSound(IsMute: bool):
	print("MuteAllRequests " + str(MuteAllRequests))
	if IsMute:
		MuteAllRequests += 1
	else:
		MuteAllRequests -= 1
		if MuteAllRequests > 0: return

	var MasterIndex = AudioServer.get_bus_index("Master")
	print("MuteAllSound " + str(IsMute))
	if !ManualMutedBuses.get(MasterIndex, false):
		AudioServer.set_bus_mute(MasterIndex, IsMute)
