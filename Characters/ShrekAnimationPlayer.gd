extends AnimationPlayer

func _ready():
	get_animation("Idle").set_loop(true)	
	get_animation("run").set_loop(true)
	get_animation("jumploop").set_loop(true)
	
	set_blend_time("jumplandtorun", "run", 0.15)
	set_blend_time("Idle", "run", 0.15)

	play("Idle")

func PlayRun():
	play("run")
	
func PlayDeath():
	clear_queue()
	play("knockbacktoback")

func PlayJump():
	clear_queue()
	
	play("Jump")
	queue("jumploop")
	
func PlayLanded():
	play("jumplandtorun")
	queue("run")
