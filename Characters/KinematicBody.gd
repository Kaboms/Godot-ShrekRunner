extends KinematicBody

export(int) var Speed = 50
export var JumpImpulse = 15
export var Gravity = -50

var Velocity = Vector3.ZERO

var MoveDistance = 100
var MoveDirection = 0
var MoveAlpha = 0
var IsJump = false

var MoveRoad = 0
var MaxMoveRoadStep = 1

var ForwardVector

# Called when the node enters the scene tree for the first time.
func _ready():
	ForwardVector = get_global_transform().basis

	Velocity = ForwardVector.z * Speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	Velocity.z = Speed * delta
	
	var rightMove = Speed * MoveDirection
	MoveAlpha += rightMove * MoveDirection * delta

	if MoveDirection != 0:
		Velocity.x = Speed * MoveDirection * delta
		if MoveAlpha >= MoveDistance:
			Velocity.x = 0
			MoveAlpha = 0
			MoveDirection = 0

	if IsJump:
		IsJump = false
		Velocity.y = JumpImpulse
		
	Velocity.y += Gravity * delta

	Velocity = move_and_slide(Velocity,  Vector3.UP)

func MoveTo(NewMoveDirection):
	if MoveDirection != 0 || abs(MoveRoad + NewMoveDirection) > MaxMoveRoadStep:
		return

	MoveDirection = NewMoveDirection
	MoveRoad += MoveDirection
	
func _on_Shrek_MoveRight():
	MoveTo(-1)

func _on_Shrek_MoveLeft():
	MoveTo(1)
	
func _on_Shrek_Jump():
	if is_on_floor():
		IsJump = true
