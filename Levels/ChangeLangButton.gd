extends Button

var CurrentLangIndex = 0
var Langs = ['ru', 'en']

export(Array, Texture) var LangsIcons = []

func _on_ChangeLangButton_pressed():
	if CurrentLangIndex + 1 >= Langs.size():
		TranslationServer.set_locale(Langs[0])
	else:
		TranslationServer.set_locale(Langs[CurrentLangIndex + 1])

func _notification(what):
	if what != NOTIFICATION_TRANSLATION_CHANGED: return

	CurrentLangIndex = Langs.find(TranslationServer.get_locale())
	set_button_icon(LangsIcons[CurrentLangIndex])
	
