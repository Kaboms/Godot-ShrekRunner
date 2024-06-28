extends KinematicBody

class_name Player

### SIGNALS
signal MoveRight
signal MoveLeft
signal Jump
signal Down

signal Death
signal StandUp

signal AddCoin

signal StartGame
###

var DeathTimeout = 0.5
var IsDeath: bool = false
var IsGameStarted: bool = false

var Coins = 0

### MOVEMENT
export(float) var SpeedIncreaseDelta = 0.005
export(float) var Speed = 7
export(int) var MaxSpeed = 10
export(int) var StrafeSpeed = 6
export(float) var StrafeDistance = 1.5

export var JumpImpulse = 10
export var Gravity = -0.5

var Velocity: Vector3 = Vector3.ZERO

var StrafeDirection = 0
var MoveRoad = 0
var DistanceToRoad = 0

var MinFallTimeout = 0.25
var FallTime = 0
var IsFall = false
var IsJump = false

var IsRoll = false
export(float) var RollDistance = 2.5
var RollStartPosZ = 0

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
export var CameraSmooth = 1.5
var MoveCameraWeight = 0
var CameraStartPoint: Vector3
var CameraStartRotation: Vector3
###

### Mouse Control
var ClickPosition: Vector2 = Vector2.ZERO
export var MouseMoveDeathzone = 0.05
###

var ActivateInputDelay = 1
var InputEnabled = false

### AUDIO
var CoinPickupSound = [
	preload("res://Audio/SFX_PickupCoin_01.WAV"),
	preload("res://Audio/SFX_PickupCoin_02.WAV"),
	preload("res://Audio/SFX_PickupCoin_04.WAV")
]

var CurrentCoinPickupSound = 0
###

### SCORE
var Score: int = 0
var ScoreMult: int = 1
var LastZPos: int = 0
var ScoreDistance: float = 0
###

var IsRestart = false

### Magnite
export(float) var MagniteDuration = 20
var MagniteTimePassed = 0
var MagniteActivated = false

var MagninteProgressInstance: ItemProgressBar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ForwardVector = get_global_transform().basis
	$AnimationPlayer.Character = $"."

func _process(delta):
	HandleCameraSetup(delta)
	HandleMagnite(delta)

	if IsGameStarted && !InputEnabled:
		ActivateInputDelay -= delta
		if ActivateInputDelay <= 0:
			InputEnabled = true

	ScoreDistance = (transform.origin.z - LastZPos)
	if (ScoreDistance >= 1):
		LastZPos = transform.origin.z
		Score += ScoreDistance * ScoreMult
		ScoreDistance = 0

func _physics_process(delta):
	HandleMovement(delta)
	HandleRoll(delta)
	
	if get_slide_count() > 0:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if (collider.get_collision_layer_bit(2)) && collision.normal.z < -0.5:
				Death()
				Velocity = move_and_slide(Vector3.ZERO, Vector3.UP)
				
				if collider is MoveableObstacle:
					collider.Destruct()
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
		if !IsRoll:
			if !is_on_floor():
				FallTime += delta
				if FallTime > MinFallTimeout:
					IsFall = true
					## If we jump animation will be controlled by jump
					if !IsJump:
						$AnimationPlayer.PlayFall()

			if FallTime != 0 && is_on_floor():
				FallTime = 0

			if IsFall && is_on_floor():
				IsFall = false
				IsJump = false
				Landed()

	Velocity.y += Gravity

	Velocity = move_and_slide(Velocity,  Vector3.UP)

func HandleRoll(delta):
	if IsRoll:
		if  transform.origin.z - RollStartPosZ > RollDistance:
			SetIsRoll(false)
			$AnimationPlayer.PlayRollUp()

func HandleCameraSetup(delta):
	if MoveCamera:
		MoveCameraDelay -= delta
		if MoveCameraDelay <= 0:
			MoveCameraWeight += CameraSmooth * delta
			MoveCameraWeight = clamp(MoveCameraWeight, 0, 1)
			$Camera.transform.origin = lerp(CameraStartPoint, $CameraPoint.transform.origin, MoveCameraWeight)
			$Camera.rotation.y = lerp_angle(CameraStartRotation.y, $CameraPoint.rotation.y, MoveCameraWeight)
			$Camera.rotation.x = lerp_angle(CameraStartRotation.x, $CameraPoint.rotation.x, MoveCameraWeight)
			
			if MoveCameraWeight == 1:
				MoveCamera = false

func StrafeTo(NewStrafeDirection):
	if !Roads.has(MoveRoad + NewStrafeDirection) || abs(DistanceToRoad) >= 0.5:
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
	CameraStartPoint = $Camera.transform.origin
	CameraStartRotation = $Camera.rotation
	
	emit_signal("StartGame")

func MoveLeft():
	StrafeTo(1)
	emit_signal("MoveLeft")

func MoveRight():
	StrafeTo(-1)
	emit_signal("MoveRight")

func Jump():
	if !IsRoll && is_on_floor() && !IsDeath:
		$AnimationPlayer.PlayJump()
		Velocity.y = JumpImpulse
		IsJump = true
		emit_signal("Jump")

func Roll():
	if !IsRoll && is_on_floor() && !IsDeath:
		$AnimationPlayer.PlayRoll()
		RollStartPosZ = transform.origin.z
		SetIsRoll(true)
		emit_signal("Down")

func SetIsRoll(InIsRoll: bool):
	IsRoll = InIsRoll
	$CapsuleCollision.disabled = IsRoll

func Restart():
	IsRestart = true

	SoundManager.MuteAllSound(false)

	var SDK: BaseSDK = StaticSDK.GetSDK()
	var BestScore = SDK.BestScore
	if BestScore < Score:
		BestScore = Score
	
	SDK.SaveStats(BestScore, SDK.Money + Coins)
	
	get_node("/root/Main").Restart()

func _input(event):
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
					if swipeDirection.y > 0:
						Roll()

func KeyboardControl(event):
	if event.is_action_pressed("Left"):
		MoveLeft()
	if event.is_action_pressed("Right"):
		MoveRight()
	if event.is_action_pressed("Jump"):
		Jump()
	if event.is_action_pressed("Down"):
		Roll()

func Death():
	if IsDeath: return
	
	SoundManager.MuteAllSound(true)
	
	SetIsRoll(false)
	IsJump = false
	IsDeath = true
	$AnimationPlayer.PlayDeath()

	Velocity = Vector3.ZERO

	ActivateMagnite(false)

	emit_signal("Death")
	
	yield(get_tree().create_timer(DeathTimeout / 2), "timeout")
	StaticSDK.GetSDK().ShowAdvBanner()

func Landed():
	if IsDeath: return

	$AnimationPlayer.PlayLanded()

func AddCoin(Coin: BaseCoin):
	$AudioStreamPlayer.stream = CoinPickupSound[CurrentCoinPickupSound]
	$AudioStreamPlayer.play()
	CurrentCoinPickupSound += 1
	if CurrentCoinPickupSound >= CoinPickupSound.size():
		CurrentCoinPickupSound = 0
	Coins += 1
	Coin.AddedToPlayer()
	emit_signal("AddCoin")
	
func StandUp():
	$AnimationPlayer.PlayStandUp()
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.PlayRun()
	IsDeath = false
	
	SoundManager.MuteAllSound(false)
	
	emit_signal("StandUp")

func HandleMagnite(delta):
	if !MagniteActivated: return

	MagniteTimePassed += delta
	MagninteProgressInstance.UpdateProgress(1 - MagniteTimePassed / MagniteDuration);

	if MagniteTimePassed >= MagniteDuration:
		ActivateMagnite(false)

func ActivateMagnite(activate: bool):
	MagniteActivated = activate
	$CoinsMagniteArea/CoinsMagniteCollision.disabled = !MagniteActivated
	MagniteTimePassed = 0
	
	if MagniteActivated:
		if MagninteProgressInstance == null:
			MagninteProgressInstance = preload("res://UI/ItemProgressBar.tscn").instance()
			get_tree().root.add_child(MagninteProgressInstance)
			MagninteProgressInstance.UpdateProgress(1)
	else:
		if MagninteProgressInstance != null:
			MagninteProgressInstance.queue_free()
			MagninteProgressInstance = null

func _on_Collision_area_entered(area):
	var AreaParent = area.get_parent()
	if AreaParent is BaseCoin:
		AddCoin(AreaParent)

func _on_CoinsMagniteCollision_area_entered(area):
	var AreaParent = area.get_parent()
	if AreaParent is BaseCoin:
		AreaParent.MoveTo($CapsuleCollision)
