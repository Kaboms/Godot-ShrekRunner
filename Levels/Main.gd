extends Spatial

var Level: LevelManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Level = $Level

func Restart():
	var BlockerInstance = preload("res://UI/Blocker.tscn").instance()
	add_child(BlockerInstance)
	$UI.Show()
	Level.queue_free()
	Level = preload("res://Levels/Level.tscn").instance()
	add_child(Level)
	BlockerInstance.queue_free()

func _on_StartButton_pressed():
	Level.StartGame()
