extends Spatial

func _on_Area_body_entered(body):
	if !(body is Player): return
	body.ActivateMagnite(true)
	
	queue_free()
