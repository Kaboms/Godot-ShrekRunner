extends Tween

export(float) var Distance = 0.5
export(float) var Speed = 1

var Parent: Spatial
var Direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Parent = $".."
	Start()
	
func _on_Tween_tween_all_completed():
	Direction *= -1
	Start()
	
func Start():
	interpolate_property(Parent, "transform",
		Parent.transform, Parent.transform.translated(Vector3(0, Distance * Direction, 0)), Speed,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	start()
