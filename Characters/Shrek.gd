extends Spatial

signal MoveRight
signal MoveLeft
signal Jump
signal Down

var IsDeath : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("run").set_loop(true)
	$AnimationPlayer.get_animation("jumploop").set_loop(true)
	
	$AnimationPlayer.set_blend_time("jumplandtorun", "run", 0.15)
	
	$AnimationPlayer.play("run")

func _input(event):
	if IsDeath: return
		
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

func Death():
	IsDeath = true
	print("Death")
	$AnimationPlayer.clear_queue()
	$AnimationPlayer.play("knockbacktoback")

func PlayJumpAnim():
	$AnimationPlayer.play("Jump")
	$AnimationPlayer.queue("jumploop")

func Landed():
	if IsDeath: return
	
	$AnimationPlayer.play("jumplandtorun")
	$AnimationPlayer.queue("run")
