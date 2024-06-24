extends Spatial

var Level: LevelManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Level = $Level

func Restart():
	$UI.Show()
	Level.queue_free()
	Level = load("res://Levels/Level.tscn").instance()
	add_child(Level)

func _on_StartButton_pressed():
	Level.StartGame()
