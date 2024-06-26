extends Node

export var RotationSpeed = 2

export var RotationAxis = Vector3.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$'..'.transform.basis = $'..'.transform.basis.rotated(RotationAxis, delta * RotationSpeed)
