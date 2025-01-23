extends CharacterBody2D


@export var speed : float = 200.0
@export var acceleration : float = 1200
@export var friction : float = 1000
@export var gravity_scale : float = 1 #אם נרצה לעשות אקסטרא עם הכוח משיכה יהיה את זה לכיף
@export var jump_velocity = -400.0
@export var gravity : float = 1000

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	jump()
	var Input_axis = Input.get_axis("move_left", "move_right")
	handle_acceleration(Input_axis, delta)
	move_and_slide()


func apply_friction(Input_axis, delta):
	if Input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta
		
func handle_acceleration(Input_axis, delta):
	if Input_axis != 0:
		velocity.x = move_toward(velocity.x, Input_axis * speed , speed * acceleration)
		print("test")
		
		
func jump():
	if is_on_floor():
		if Input.is_action_just_pressed("move_up"):
			velocity.y = jump_velocity
	else: #חצי קפיצה בשיחרור המקש
		if Input.is_action_just_released("move_up") and velocity.y < jump_velocity / 2:
				velocity.y = jump_velocity / 2
