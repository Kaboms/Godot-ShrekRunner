extends Spatial

var GameStarted = false
var TimePassed = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if !GameStarted: return
	
	TimePassed += delta
	if TimePassed > 5:
		queue_free()

func _on_Shrek_StartGame():
	GameStarted = true
