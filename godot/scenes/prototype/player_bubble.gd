extends CharacterBody2D

@export var playerName: String
@onready var label: Label = $Label



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
	display_text() ##use when player lost a round, connet  pla <3

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	jump()
	var input_axis = Input.get_axis(left_input_name, right_input_name)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	move_and_slide()


func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		

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
			label.show()
	else: #חצי קפיצה בשיחרור המקש
		if Input.is_action_just_released(up_input_name) and velocity.y < jump_velocity / 2:
				velocity.y = jump_velocity / 2
				


func display_text():
	var write_speed := 3
	var tween := create_tween()
	var duration := label.text.length() / write_speed
	tween.tween_property(label, "visible_ratio", 1.0, duration)\
		.from(0.0)
