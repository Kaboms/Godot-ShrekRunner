extends Spatial

class_name BaseCoin

export var CoinAmount: int = 1
var Target: Spatial = null
var Speed: float = 2
var StartPos: Vector3
var MoveAlpha: float = 0.0

func _process(delta):
	if Target == null: return
	MoveAlpha += Speed * delta
	MoveAlpha = clamp(MoveAlpha, 0, 1)
	global_transform.origin = lerp(StartPos, Target.global_transform.origin, MoveAlpha)

func AddedToPlayer():
	queue_free()

func MoveTo(NewTarget: Spatial):
	Target = NewTarget
	StartPos = global_transform.origin
