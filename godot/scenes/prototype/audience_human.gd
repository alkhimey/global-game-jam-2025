extends Node2D

var shirt_color: Color = Color.WHITE
var seat_target: float
var playerId: int
var sign_type: int
# var skin_color: int
var seat: int

@export var walk_speed: float = 5
@export var starting_side: Array = [-10, 890, 580]
# @export var starting_height: Array = [105, 186, 272, 366, 456]
@export var seats: Array = [[Vector2(50, 152), Vector2(167, 152), Vector2(64, 318), Vector2(129, 317), Vector2(239, 455), Vector2(311, 443), Vector2(377, 440)],
							[Vector2(536, 282), Vector2(594, 282), Vector2(770, 144), Vector2(763, 339), Vector2(456, 437), Vector2(523, 444), Vector2(592, 455)]]
# @export var player2_seats: Array = [770, 827]
@export var body_sprites: Array = []
@export var eyes_sprites: Array = []
@export var head_sprites: Array = []
@export var wing_sprites: Array = []
@export var halo_sprites: Array = []
# @export var jump_offset: Vector2 = Vector2(0, 3)
@export var goal_time: float = 2.0
@export var curses: Array = ["@!%#$*@#$$", "@!#(*!*)@#$@#", "$!*@!*!$@#%@#$", "!&%$%#$*$#%"]

@onready var body_node = $Body
@onready var head_node = $Head
@onready var hand_node = $Hands
@onready var eyes_node = $Head/Eyes
@onready var wing_node_L = $Body/Wings/WingL
@onready var wing_node_R = $Body/Wings/WingR
@onready var halo_node = $Head/Halo
@onready var head_sign_node = $Hands/HeadSign
@onready var body_sign_node = $Hands/BodySign
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.goal.connect(on_goal)
	# change_speed(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_tween():
	var tween = create_tween()
	animation_player.play("walk")

	match seat:
		0, 1, 2, 3:
			tween.tween_property(self, "position:x", seat_target, walk_speed).set_trans(Tween.TRANS_QUART)
		_:
			tween.tween_property(self, "position:y", seat_target, walk_speed).set_trans(Tween.TRANS_QUART)

	# await tween.finished

	# animation_player.play("idle")


func change_player(_playerId: int):

	sign_type = randi_range(0,4)
	head_node.texture = head_sprites[1]

	match sign_type:
		0,1:
			pass
		2,3:
			body_sign_node.visible = true
			head_node.texture = head_sprites[0]
		4:
			head_sign_node.visible = true

	body_node.texture = body_sprites.pick_random()
	halo_node.texture = halo_sprites.pick_random()
	
	var eye_texture = randi_range(0, eyes_sprites.size() - 1)
	eyes_node.texture = eyes_sprites[eye_texture]
	if eye_texture < 2:
		eyes_node.scale = Vector2(0.3, 0.3)
		eyes_node.position = Vector2(0.05, 0.25)
	else:
		eyes_node.scale = Vector2(1., 1.)
		eyes_node.position = Vector2(0.01, 0.03)

	var wing_texture = wing_sprites.pick_random()
	wing_node_L.texture = wing_texture
	wing_node_R.texture = wing_texture

	playerId = _playerId
	# position.x = starting_side[_playerId]
	shirt_color = GameplayGlobal.player_colors[playerId - 1]
	body_node.modulate = shirt_color
	head_sign_node.modulate = shirt_color
	body_sign_node.modulate = shirt_color

	# @warning_ignore("integer_division")
	# position.y = starting_height[seat / 2]
	# position.x = starting_side[playerId]

	# match playerId:
	# 	1:
	# 		# @warning_ignore("integer_division")
	# 		# seat_target = player1_width[seat / 5]
	# 	2:
	# 		@warning_ignore("integer_division")
	# 		seat_target = player2_width[seat / 5]

	match seat:
		0, 1, 2, 3:
			position.y = seats[playerId - 1][seat].y
			position.x = starting_side[playerId - 1]
			seat_target = seats[playerId - 1][seat].x
		_:
			position.x = seats[playerId - 1][seat].x
			position.y = starting_side[2]
			seat_target = seats[playerId - 1][seat].y

	start_tween()


func on_goal(_playerId: int):
	if _playerId == playerId:
		animation_player.play("goal")

		await get_tree().create_timer(goal_time).timeout

		animation_player.play("walk")
		return
		# change_speed(3)
		# start_tween()


func almost_goal():
	pass
	# change_speed(2)
	# start_tween()
