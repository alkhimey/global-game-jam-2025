extends Node2D

var shirt_color: Color = Color.WHITE
var current_speed: float
var initial_height: float
var playerId

@export var skin_colors: Array = [Color.SALMON, Color.BROWN, Color.LIGHT_PINK, Color.SANDY_BROWN]
@export var jump_offset: Vector2 = Vector2(0, 3)
@export var normal_speed: float = 5
@export var excite_speed: float = 0.5
@export var goal_speed: float = 0.2

@onready var body_node = $Body
@onready var head_node = $Head


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.goal.connect(on_goal)
	initial_height = position.y
	change_speed(1)

	change_shirt()
	head_node.modulate = skin_colors.pick_random()
	start_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_tween():
	var tween = create_tween().set_loops()

	tween.tween_property(self, "position:y", initial_height + jump_offset.y, current_speed).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "position:y", initial_height, current_speed).set_trans(Tween.TRANS_QUART)


func change_player(playerId: int):
	body_node.modulate = shirt_color


func change_speed(speed_level: int):
	match speed_level:
		1:
			current_speed = normal_speed
		2:
			current_speed = excite_speed
		3:
			current_speed = goal_speed


func on_goal(_playerId: int):
	if _playerId == playerId:
		change_speed(3)
		start_tween()
