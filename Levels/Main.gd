extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Level: LevelManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Level = $Level

func Restart():
	$UI.Show()
	Level.queue_free()
	Level = load("res://Levels/Level.tscn").instance()
	add_child(Level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartGameButton_button_down():
	Level.StartGame()
