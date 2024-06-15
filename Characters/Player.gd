extends KinematicBody

class_name Player

### SIGNALS
signal MoveRight
signal MoveLeft
signal Jump
signal Down

signal Death

signal AddCoin

signal StartGame
###

var DeathTimeout = 1
var IsDeath: bool = false
var IsGameStarted: bool = false

var Coins = 0

### MOVEMENT
export(float) var SpeedIncreaseDelta = 0.005
export(float) var Speed = 4.5
export(int) var MaxSpeed = 8
export(int) var StrafeSpeed = 6
export(float) var StrafeDistance = 1.5

export var JumpImpulse = 10
export var Gravity = -0.5

var Velocity: Vector3 = Vector3.ZERO

var StrafeDirection = 0
var MoveRoad = 0
var DistanceToRoad = 0

var IsFall = false
var IsJump = false

# KISS
var Roads = {
	-1: -StrafeDistance,
	0: 0,
	1: StrafeDistance
}

var ForwardVector
###

### CAMERA
var MoveCameraDelay = 0.3
var MoveCamera = false
export var CameraSpeed = 0.1
var MoveCameraWeight = 0

###

### Mouse Control
var ClickPosition: Vector2 = Vector2.ZERO
export var MouseMoveDeathzone = 0.05
###

var ActivateInputDelay = 1
var InputEnabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ForwardVector = get_global_transform().basis
	$AnimationPlayer.Character = $"."

func _process(delta):
	HandleCameraSetup(delta)
	
	if IsGameStarted && !InputEnabled:
		ActivateInputDelay -= delta
		if ActivateInputDelay <= 0:
			InputEnabled = true

func _physics_process(delta):
	HandleMovement(delta)
	
	if get_slide_count() > 0:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if (collider.get_collision_layer_bit(2)) && collision.normal.z < -0.5:
				Death()
				Velocity = move_and_slide(Vector3.ZERO, Vector3.UP)
				break

func HandleMovement(delta):
	Velocity.z = 0
	Velocity.x = 0

	if IsDeath && DeathTimeout > 0:
		DeathTimeout -= delta

	if !IsDeath:
		if IsGameStarted:
			if Speed < MaxSpeed:
				Speed += SpeedIncreaseDelta * delta
			Velocity.z = Speed
			
			if StrafeDirection != 0:
				DistanceToRoad = (Roads[MoveRoad] - transform.origin.x) * StrafeDirection 
				if DistanceToRoad >= 0:
					Velocity.x = StrafeSpeed * StrafeDirection
				else:
					transform.origin.x = Roads[MoveRoad]
					StrafeDirection = 0
		if !is_on_floor():
			IsFall = true
			## If we jump animation will be controlled by jump
			if !IsJump:
				$AnimationPlayer.PlayFall()
			
		if IsFall && is_on_floor():
			IsFall = false
			IsJump = false
			Landed()

	Velocity.y += Gravity

	Velocity = move_and_slide(Velocity,  Vector3.UP)

func HandleCameraSetup(delta):
	if MoveCamera:
		MoveCameraDelay -= delta
		if MoveCameraDelay <= 0:
			MoveCameraWeight += CameraSpeed * delta
			MoveCameraWeight = clamp(MoveCameraWeight, 0, 1)
			$Camera.transform.origin = lerp($Camera.transform.origin, $CameraPoint.transform.origin, MoveCameraWeight)
			$Camera.rotation.y = lerp_angle($Camera.rotation.y, $CameraPoint.rotation.y, MoveCameraWeight)
			$Camera.rotation.x = lerp_angle($Camera.rotation.x, $CameraPoint.rotation.x, MoveCameraWeight)
			
			if MoveCameraWeight == 1:
				MoveCamera = false

func StrafeTo(NewStrafeDirection):
	if !Roads.has(MoveRoad + NewStrafeDirection) || abs(DistanceToRoad) >= 0.25:
		return

	StrafeDirection = NewStrafeDirection
	MoveRoad += StrafeDirection

func StartGame():
	if IsGameStarted: return
	
	get_node("../StartPosition/Outdoor").get_node("AnimationPlayer").play("Open")
	yield(get_tree().create_timer(0.25), "timeout")

	IsGameStarted = true
	
	$AnimationPlayer.PlayRun()

	MoveCamera = true

	emit_signal("StartGame")

func MoveLeft():
	StrafeTo(1)
	emit_signal("MoveLeft")

func MoveRight():
	StrafeTo(-1)
	emit_signal("MoveRight")

func Jump():
	if is_on_floor() && !IsDeath:
		$AnimationPlayer.PlayJump()
		Velocity.y = JumpImpulse
		IsJump = true
		emit_signal("Jump")
		
func _input(event):
	if (event is InputEventMouseButton && event.pressed) || event.is_action_pressed("Jump"):
		if !IsGameStarted:
			StartGame()
			return
		elif IsDeath &&  DeathTimeout <= 0:
			get_node("/root/Main").Restart()

	if !event.is_action_type() || !InputEnabled: return

	SwipeControl(event)
	KeyboardControl(event)

func SwipeControl(event):
	if event is InputEventMouseButton:
		if event.pressed:
			ClickPosition = event.position
		else:
			var swipeDirection = event.position - ClickPosition
			var swipeDistance = swipeDirection / get_viewport().size
			if abs(swipeDistance.x) >= MouseMoveDeathzone || abs(swipeDistance.y) >= MouseMoveDeathzone:
				if abs(swipeDirection.x) > abs(swipeDirection.y):
					if swipeDirection.x > 0:
						MoveRight()
					else:
						MoveLeft()
				else:
					if swipeDirection.y < 0:
						Jump()

func KeyboardControl(event):
	if event.is_action_pressed("Left"):
		MoveLeft()
	if event.is_action_pressed("Right"):
		MoveRight()
	if event.is_action_pressed("Jump"):
		Jump()
	if event.is_action_pressed("Down"):
		emit_signal("Down")

func Death():
	if IsDeath: return
	
	IsDeath = true
	$AnimationPlayer.PlayDeath()

	Velocity = Vector3.ZERO

	emit_signal("Death")

func Landed():
	if IsDeath: return

	$AnimationPlayer.PlayLanded()

func AddCoin():
	Coins += 1
	emit_signal("AddCoin")
