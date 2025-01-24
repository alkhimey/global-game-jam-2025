extends CharacterBody2D

@export var playerId: int
@export var chat_bubble: Label

# Name for left input
@export var left_input_name: String = "player1_left"
# Name for right input
@export var right_input_name: String = "player1_right"
# Name for up input
@export var up_input_name: String = "player1_up"
# List of curses for the player
@export var curses: Array = ["@!%#$*", "@!#(*!*)", "$!*@!*!$"]
# Starting position on reset
@export var initial_position: Vector2 = Vector2(0,0)
# Position offset for chat bubble
@export var chat_offset: Vector2 = Vector2(0,0)

#speed of typing animation
@export var write_speed := 8

const meterToPixel = 100 # 480 pixels = 4.8meter = 1 second of free fall from top to bottom
const pixelToMeter = 1.0 / meterToPixel
const massKG = 5
const gravityAcceleration = 9.8
const restingVelocityYThreshold = 1.0
const restingVelocityXThreshold = 50.0

@export var frictionCoeff : float = 0.5
@export var airDragCoeff : float = 0.47
@export var inputAccelerationAir : float = 5
@export var inputAccelerationFloor : float = 13

@export var coeffOfRestitutionWithFloor : float = 0.3
const jumpSpeed : float = -600 # m/s

var collidedWithFloorLastPass : bool = false

const jumpRequestTimeoutMs = 300
var lastJumpRequestTimeMs: int = 0
var lastJumpRequestTimeValid: bool = false

var lastFloorTimeMs: int = 0
var lastFloorTimeValid: bool = false

func _ready() -> void:
	GameplayGlobal.goal_reset.connect(on_goal_reset)
	GameplayGlobal.goal.connect(display_text)
	# display_text()

func _physics_process(delta: float) -> void:
	var collidedWithFloorThisPass = false
	var input_axis = 0
	if GameplayGlobal.can_goal:
		input_axis = Input.get_axis(left_input_name, right_input_name)

	apply_forces(input_axis, delta)	
	var prevVelocity = velocity

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().get_class() == "CharacterBody2D" and playerId == 1:
			var selfVelInNormalDir = prevVelocity.project(collision.get_normal())
			var selfVelCrossNormalDir = prevVelocity - selfVelInNormalDir
			
			var otherPlayer: CharacterBody2D = collision.get_collider()
			var otherVelInNormalDir = otherPlayer.velocity.project(-1.0 * collision.get_normal())
			var otherVelCrossNormalDir = otherPlayer.velocity - otherVelInNormalDir			

			velocity = otherVelInNormalDir + selfVelCrossNormalDir
			otherPlayer.velocity = otherVelCrossNormalDir + selfVelInNormalDir

		if collision.get_collider().name == "Floor":
			velocity = prevVelocity.bounce(collision.get_normal()) 
			if collidedWithFloorLastPass == false:
				velocity = velocity * (1 - coeffOfRestitutionWithFloor)
			collidedWithFloorThisPass = true
			#if abs(velocity.x) < restingVelocityXThreshold * meterToPixel:
				#velocity.x = 0.0
			if abs(velocity.y) < restingVelocityYThreshold * meterToPixel:
				velocity.y = 0.0
	jump()

	collidedWithFloorLastPass = collidedWithFloorThisPass

func apply_forces(input_axis, delta):
	var velocityMeters = velocity * pixelToMeter
	
	var gravityF = Vector2.ZERO
	if not is_on_floor():
		gravityF.y += gravityAcceleration * massKG
	
	var frictionF = Vector2.ZERO
	if input_axis == 0 and is_on_floor():
		frictionF.x = -1.0 * velocityMeters.x * frictionCoeff
	
	var airResistanceF = -1.0 * velocityMeters * velocityMeters.length() * airDragCoeff	
	
	var inputF = Vector2.ZERO
	if input_axis != 0:
		var inputAcceleration = inputAccelerationFloor if is_on_floor() else inputAccelerationAir
		inputF.x = inputAcceleration * massKG * input_axis
	
	var totalForce = gravityF + inputF + frictionF + airResistanceF 
	var totalAcceleration = totalForce / massKG
	
	velocity += totalAcceleration * delta * meterToPixel
	#print(velocity, totalAcceleration)
	
func jump():
	
	#debug
	var debug = $DebugLabel
	#debug.hidden = false
	var debugText = ""
	
	debugText += "F " if is_on_floor() else "X "
	
	if is_on_floor():
		lastFloorTimeMs = Time.get_ticks_msec()
		lastFloorTimeValid = true
	
	debugText += "I " if Input.is_action_just_pressed(up_input_name) else "X "

	debugText += "V " if lastFloorTimeValid else "X "
	debugText += "V " if lastJumpRequestTimeValid else "X "

	
	if Input.is_action_just_pressed(up_input_name):
		print("Pressed ", Time.get_ticks_msec() )
		lastJumpRequestTimeMs = Time.get_ticks_msec()
		lastJumpRequestTimeValid = true
		
	if lastFloorTimeValid and \
		Time.get_ticks_msec() - lastFloorTimeMs < jumpRequestTimeoutMs and \
		lastJumpRequestTimeValid and \
		Time.get_ticks_msec() - lastJumpRequestTimeMs < jumpRequestTimeoutMs:
		print("Jumped ", Time.get_ticks_msec()  )
		velocity.y = jumpSpeed
		lastJumpRequestTimeValid = false
		lastFloorTimeValid = false
		
	
	if Time.get_ticks_msec() - lastJumpRequestTimeMs > jumpRequestTimeoutMs:
		lastJumpRequestTimeValid = false
	if Time.get_ticks_msec() - lastFloorTimeMs > jumpRequestTimeoutMs:
		lastFloorTimeValid = false
	
	debug.text = debugText

func display_text(_playerid: int):
	if _playerid == playerId:
		return
		
		
	chat_bubble.show()
	chat_bubble.text = curse()
	
	
	var tween := create_tween()
	var duration := chat_bubble.text.length() / write_speed

	tween.tween_property(chat_bubble, "visible_ratio", 1.0, duration) \
		.from(0.0)
		
		
		
func curse() -> String: 
	if not curses.is_empty():
		return curses.pick_random()
	
	return "-------"


func on_goal_reset():
	position = initial_position
	chat_bubble.hide()


func _process(delta):
	chat_bubble.position = position + chat_offset
	
	
