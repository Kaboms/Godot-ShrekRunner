extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	StaticSDK.GetSDK().connect("MoneyChanged", self, "OnMoneyChanged")
	
func OnMoneyChanged(newMoney):
	set_text(str(newMoney))

