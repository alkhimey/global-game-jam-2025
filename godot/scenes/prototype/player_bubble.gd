extends CharacterBody2D

@export var playerId: int
@export var chat_bubble: Label

@export var image1: Sprite2D
@export var image2: Sprite2D

# Name for left input
@export var left_input_name: String = "player1_left"
# Name for right input
@export var right_input_name: String = "player1_right"
# Name for up input
@export var up_input_name: String = "player1_up"
# Name for down input
@export var down_input_name: String = "player1_down"

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
const gravityAcceleration = 0.8
const restingVelocityYThreshold = 1.0 # If velocity.x is below it, set velocity.x to 0
const restingVelocityXThreshold = 50.0 # If velocity.x is below it, set velocity.x to 0

@export var frictionCoeff : float = 1.7

# Applies on the gound and in all direction
@export var airDragCoeff : float = 0.47 

# Input acceleration when touching the floor
@export var inputAccelerationAir : float = 7

# Input acceleration when not touching the floor
@export var inputAccelerationFloor : float = 9

# If speed.x is above this value, input acceleration will not be applied.
const inputAccelerationMaxSpeed = 2.5 

@export var coeffOfRestitutionWithFloor : float = 0.2

# Speed boost upwards when pressing up. m/s
const jumpSpeed : float = -350

# Speed boost downwards when pressing down midair. m/2
const downSpeed : float = 300

var collidedWithFloorLastPass : bool = false

const jumpRequestTimeoutMs = 300
var lastJumpRequestTimeMs: int = 0
var lastJumpRequestTimeValid: bool = false

var lastFloorTimeMs: int = 0
var lastFloorTimeValid: bool = false

func _ready() -> void:
	image1.visible = playerId == 1
	image2.visible = playerId == 2
	
			
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
	trail_effect()
	
		
		
	# BUG: multiple collisions can be with the other player. Need to use move_and_collide.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().get_class() == "CharacterBody2D":			
			var selfVelInNormalDir = prevVelocity.project(collision.get_normal())
			var selfVelCrossNormalDir = prevVelocity - selfVelInNormalDir
			
			var otherPlayer: CharacterBody2D = collision.get_collider()
			var otherVelInNormalDir = otherPlayer.velocity.project(-1.0 * collision.get_normal())
			var otherVelCrossNormalDir = otherPlayer.velocity - otherVelInNormalDir			
			velocity = otherVelInNormalDir + selfVelCrossNormalDir
			otherPlayer.velocity = otherVelCrossNormalDir + selfVelInNormalDir


		elif collision.get_collider().name == "Floor":
			velocity = prevVelocity.bounce(collision.get_normal()) 
			if collidedWithFloorLastPass == false:
				velocity = velocity * (1 - coeffOfRestitutionWithFloor)
			collidedWithFloorThisPass = true
			#if abs(velocity.x) < restingVelocityXThreshold * meterToPixel:
				#velocity.x = 0.0
			if abs(velocity.y) < restingVelocityYThreshold * meterToPixel:
				velocity.y = 0.0
		else:
			velocity = prevVelocity.bounce(collision.get_normal()) 
	jump()
	if Input.is_action_just_pressed(down_input_name):
		velocity.y = downSpeed
		
	# This is instead of the jump.
	if Input.is_action_just_pressed(up_input_name):
		velocity.y = 1.5 * -downSpeed

	collidedWithFloorLastPass = collidedWithFloorThisPass
	
	print(velocity.length())

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
	if input_axis != 0 and abs(velocityMeters.x) < inputAccelerationMaxSpeed:
		var inputAcceleration = inputAccelerationFloor if is_on_floor() else inputAccelerationAir
		inputF.x = inputAcceleration * massKG * input_axis
	
	var totalForce = gravityF + inputF + frictionF + airResistanceF 
	var totalAcceleration = totalForce / massKG
	
	velocity += totalAcceleration * delta * meterToPixel
	#print(velocity, totalAcceleration)
	
func jump():
	if is_on_floor():
		lastFloorTimeMs = Time.get_ticks_msec()
		lastFloorTimeValid = true

	# Jump is temporarily disabled
	#if Input.is_action_just_pressed(up_input_name):
		#lastJumpRequestTimeMs = Time.get_ticks_msec()
		#lastJumpRequestTimeValid = true
		
	if lastFloorTimeValid and \
		Time.get_ticks_msec() - lastFloorTimeMs < jumpRequestTimeoutMs and \
		lastJumpRequestTimeValid and \
		Time.get_ticks_msec() - lastJumpRequestTimeMs < jumpRequestTimeoutMs:
		velocity.y += jumpSpeed
		lastJumpRequestTimeValid = false
		lastFloorTimeValid = false

	if Time.get_ticks_msec() - lastJumpRequestTimeMs > jumpRequestTimeoutMs:
		lastJumpRequestTimeValid = false
	if Time.get_ticks_msec() - lastFloorTimeMs > jumpRequestTimeoutMs:
		lastFloorTimeValid = false

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
	#position = initial_position
	chat_bubble.hide()


func _process(delta):
	chat_bubble.position = position + chat_offset
	

func trail_effect():
	var particles = get_node("GPUParticles2D") 
	var particles_textures = [
		preload("res://Assets/ggj-bubble-blue-64.png"),
		preload("res://Assets/ggj-bubble-red-64.png")
		]
	var _material = particles.process_material 
	if playerId == 1:
		particles.texture =  particles_textures[0]
	else:
		particles.texture =  particles_textures[1]
	var _scale_factor = 1 + velocity.length() / 60000	  # Make the particles smaller
	_material.scale = Vector2(_scale_factor ,_scale_factor)
	

	var trail = get_node("GPUParticles2D")# Directly access the node
	if velocity.length() > 400:  # Activate trail when moving
		trail.emitting = true
	else:
		trail.emitting = false
	
		
		
		

		
