extends KinematicBody

class_name ShrekCharacter

### SIGNALS
signal MoveRight
signal MoveLeft
signal Jump
signal Down

signal Death

signal StartGame
###

var IsDeath: bool = false
var IsGameStarted: bool = false

### MOVEMENT
export(int) var Speed = 300
export(int) var StrafeSpeed = 600
export(int) var StrafeDistance = 1.5

export var JumpImpulse = 15
export var Gravity = -50

var Velocity = Vector3.ZERO

var StrafeDirection = 0
var MoveRoad = 0
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
export var CameraSpeed = 3
###

### Mouse Control
var ClickPosition: Vector2 = Vector2.ZERO
export var MouseMoveDeathzone = 100
###

# Called when the node enters the scene tree for the first time.
func _ready():
	ForwardVector = get_global_transform().basis	

func _physics_process(delta):
	HandleMovement(delta)
	HandleCameraSetup(delta)
	
	if get_slide_count() > 0:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if (collider.get_collision_layer_bit(2)) && collision.normal.z < -0.5:
				Death()
				move_and_slide(Vector3.ZERO, Vector3.UP)
				break

func HandleMovement(delta):
	Velocity.z = 0
	
	if !IsDeath && IsGameStarted:
		Velocity.z = Speed * delta

		if StrafeDirection != 0:
			if ((Roads[MoveRoad] - transform.origin.x) * StrafeDirection >= 0):
				Velocity.x = StrafeSpeed * StrafeDirection * delta
			else:
				Velocity.x = 0
				StrafeDirection = 0
			
	Velocity.y += Gravity * delta

	if !is_on_floor():
		IsJump = true
		
	if IsJump && is_on_floor():
		IsJump = false	
		Landed()
		
	Velocity = move_and_slide(Velocity,  Vector3.UP)

func HandleCameraSetup(delta):
	if MoveCamera:
		MoveCameraDelay -= delta
		if MoveCameraDelay <= 0:
			var MoveCameraWeight = CameraSpeed * delta
			$Camera.transform.origin = lerp($Camera.transform.origin, $CameraPoint.transform.origin, MoveCameraWeight)
			$Camera.rotation.y = lerp_angle($Camera.rotation.y, $CameraPoint.rotation.y, MoveCameraWeight)
			$Camera.rotation.x = lerp_angle($Camera.rotation.x, $CameraPoint.rotation.x, MoveCameraWeight)

func StrafeTo(NewStrafeDirection):
	if !Roads.has(MoveRoad + NewStrafeDirection) || StrafeDirection != 0:
		return

	StrafeDirection = NewStrafeDirection
	MoveRoad += StrafeDirection

func StartGame():
	get_node("../Outdoor").get_node("AnimationPlayer").play("Open")	
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
	if is_on_floor():
		$AnimationPlayer.PlayJump()
		Velocity.y = JumpImpulse
		emit_signal("Jump")
		
func _input(event):
	if !event.is_action_type(): return

	if event is InputEventMouseButton:
		if event.pressed:
			ClickPosition = event.position
		elif ClickPosition.distance_to(event.position) > MouseMoveDeathzone:
			var SwipeDirection = event.position - ClickPosition
			if abs(SwipeDirection.x) > abs(SwipeDirection.y):
				if SwipeDirection.x > 0:
					MoveRight()
				else:
					MoveLeft()
			else:
				if SwipeDirection.y < 0:
					Jump()
		
	if !IsGameStarted:
		StartGame()

	if IsDeath:
		get_tree().reload_current_scene()

	if event.is_action_pressed("Left"):
		MoveLeft()
	if event.is_action_pressed("Right"):
		MoveRight()
	if event.is_action_pressed("Jump"):
		Jump()
	if event.is_action_pressed("Down"):
		emit_signal("Down")

func Death():
	IsDeath = true
	$AnimationPlayer.PlayDeath()

	Velocity = Vector3.ZERO

	emit_signal("Death")

func Landed():
	if IsDeath || !IsGameStarted: return

	$AnimationPlayer.PlayLanded()
