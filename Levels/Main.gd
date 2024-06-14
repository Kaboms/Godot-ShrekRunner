extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Level

# Called when the node enters the scene tree for the first time.
func _ready():
	Level = $Level
	pass # Replace with function body.


func Restart():
	Level.queue_free()
	Level = load("res://Levels/Level.tscn").instance()
	add_child(Level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
