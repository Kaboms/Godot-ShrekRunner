extends Spatial

export var CoinAmount: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body is Player:
		body.AddCoin()
	queue_free()
