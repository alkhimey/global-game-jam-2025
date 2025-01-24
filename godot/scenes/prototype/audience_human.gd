extends Node2D

var shirt_color: Color = Color.WHITE
var initial_width: float
var playerId: int
var sign_type: int
var skin_color: int

@export var speed: float = 5
@export var starting_side: Array = [-20, -10, 864]
@export var starting_height: Array = [226, 186, 276]
@export var body_sprites: Array = []
@export var eyes_sprites: Array = []
@export var head_sprites: Array = []
@export var jump_offset: Vector2 = Vector2(0, 3)
@export var normal_speed: float = 5
@export var excite_speed: float = 0.5
@export var goal_speed: float = 0.2

@onready var body_node = $Body
@onready var head_node = $Head
@onready var hand_node = $Hands
@onready var head_sign_node = $Hands/HeadSign
@onready var body_sign_node = $Hands/BodySign


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.goal.connect(on_goal)
	position.y = starting_height.pick_random()
	# change_speed(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_tween():
	var tween = create_tween()

	tween.tween_property(self, "position:x", initial_width, speed).set_trans(Tween.TRANS_QUART)


func change_player(_playerId: int):

	sign_type = randi_range(0,2)
	match sign_type:
		0:
			pass
		1:
			body_sign_node.visible = true
		2:
			head_sign_node.visible = true

	playerId = _playerId
	position.x = starting_side[_playerId]

	if playerId > 0:
		shirt_color = GameplayGlobal.player_colors[playerId - 1]

	body_node.modulate = shirt_color
	head_sign_node.modulate = shirt_color
	body_sign_node.modulate = shirt_color

	match playerId:
		1:
			initial_width = randf_range(0., 854. / 2.)
		2:
			initial_width = randf_range(854. / 2., 854.)

	if playerId > 0:
		start_tween()


func on_goal(_playerId: int):
	if _playerId == playerId:
		pass
		# change_speed(3)
		# start_tween()


func almost_goal():
	pass
	# change_speed(2)
	# start_tween()
