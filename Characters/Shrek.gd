extends Spatial

signal MoveRight
signal MoveLeft
signal Jump
signal Down

# Called when the node enters the scene tree for the first time.
func _ready():
	var RanAnimation = $AnimationPlayer.get_animation("run")
	RanAnimation.set_loop(true)

	$AnimationPlayer.play("run")

func _input(event):
	if event.is_action_pressed("Left"):
		emit_signal("MoveLeft")
	if event.is_action_pressed("Right"):
		emit_signal("MoveRight")
	if event.is_action_pressed("Jump"):
		emit_signal("Jump")
		PlayJumpAnim()
	if event.is_action_pressed("Down"):
		emit_signal("Down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func PlayJumpAnim():
	$AnimationPlayer.play("Jump")
	yield( get_node("AnimationPlayer"), "animation_finished" )
	$AnimationPlayer.play("jumplandtorun")
	yield( get_node("AnimationPlayer"), "animation_finished" )
	$AnimationPlayer.play("run", 0.15)

func Landed():
	pass
