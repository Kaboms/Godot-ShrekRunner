extends Spatial

class_name MoveableObstacle

export(float) var Speed = 13

export(bool) var Activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if !Activated: return

	transform.origin.x -= Speed * delta * Global.SpeedAlpha

func Destruct():
	#TODO add VFX
	queue_free()
