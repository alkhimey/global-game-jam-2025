extends CharacterBody2D

@export var playerId: int
@export var chat_bubble: Label

@export var left_input_name: String = "player1_left"
@export var right_input_name: String = "player1_right"
@export var up_input_name: String = "player1_up"


@export var speed : float = 250
@export var acceleration : float = 800
@export var friction : float = 1000
@export var gravity_scale : float = 1 #אם נרצה לעשות אקסטרא עם הכוח משיכה יהיה את זה לכיף
@export var jump_velocity = -400.0
@export var gravity : float = 1000

func _ready() -> void:
	pass
	
	# display_text()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	jump()
	var input_axis = Input.get_axis(left_input_name, right_input_name)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_friction(input_axis, delta)
	var prevVelocity = velocity
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Floor":
			lose_speed_at_collision()
			if prevVelocity.length() > 100:
				velocity = prevVelocity.bounce(collision.get_normal()) 
		print("I collided with ", collision.get_normal())

	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info:
		#if collision_info.get_collider().name == "Floor":
			#if velocity.length() < 100:
				#velocity = Vector2.ZERO
			#else:
				#velocity = velocity.bounce(collision_info.get_normal()) 

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_air_friction(input_axis, delta):
	# Approximation - air friction
	velocity.x = move_toward(velocity.x, 0, 300 * delta)	
	velocity.y = move_toward(velocity.y, 0, 300 * delta)	

func lose_speed_at_collision():		
	if velocity.y - 30.0 <= 0.0:
		velocity.y = 0.0
	else:
		velocity.y = velocity.y - 30.0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta
		
func handle_acceleration(Input_axis, delta):
	if Input_axis != 0:
		velocity.x = move_toward(velocity.x, Input_axis * speed, speed * acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * acceleration * delta)
		
func jump():
	if is_on_floor():
		if Input.is_action_just_pressed(up_input_name):
			velocity.y = jump_velocity
	else: #חצי קפיצה בשיחרור המקש
		if Input.is_action_just_released(up_input_name) and velocity.y < jump_velocity / 2:
				velocity.y = jump_velocity / 2
				


func display_text():
	chat_bubble.show()
	chat_bubble.text = curse()
	
	var write_speed := 3
	var tween := create_tween()
	var duration := chat_bubble.text.length() / write_speed
	tween.tween_property(chat_bubble, "visible_ratio", 1.0, duration)\
		.from(0.0)
		
		
		
func curse() -> String: 
	return ["@!%#$*", "@!#(*!*)", "$!*@!*!$"].pick_random()
	
	
