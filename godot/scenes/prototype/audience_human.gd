extends Node2D

var shirt_color: Color = Color.WHITE
var initial_width: float
var playerId: int
var sign_type: int
var skin_color: int
var seat: int

@export var speed: float = 5
@export var starting_side: Array = [-20, -10, 864]
@export var starting_height: Array = [105, 186, 272, 366, 456]
@export var player1_width: Array = [26, 85]
@export var player2_width: Array = [770, 827]
@export var body_sprites: Array = []
@export var eyes_sprites: Array = []
@export var head_sprites: Array = []
@export var wing_sprites: Array = []
@export var halo_sprites: Array = []
@export var jump_offset: Vector2 = Vector2(0, 3)
@export var normal_speed: float = 5
@export var excite_speed: float = 0.5
@export var goal_speed: float = 0.2

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

	tween.tween_property(self, "position:x", initial_width, speed).set_trans(Tween.TRANS_QUART)

	await tween.finished

	animation_player.play("idle")


func change_player(_playerId: int):

	sign_type = randi_range(0,2)
	head_node.texture = head_sprites[1]

	match sign_type:
		0:
			pass
		1:
			body_sign_node.visible = true
			head_node.texture = head_sprites[0]
		2:
			head_sign_node.visible = true

	body_node.texture = body_sprites.pick_random()
	eyes_node.texture = eyes_sprites.pick_random()
	halo_node.texture = halo_sprites.pick_random()
	
	var wing_texture = wing_sprites.pick_random()
	wing_node_L.texture = wing_texture
	wing_node_R.texture = wing_texture

	playerId = _playerId
	position.x = starting_side[_playerId]

	if playerId > 0:
		shirt_color = GameplayGlobal.player_colors[playerId - 1]

	body_node.modulate = shirt_color
	head_sign_node.modulate = shirt_color
	body_sign_node.modulate = shirt_color

	position.y = starting_height[seat / 2]
	position.x = starting_side[playerId]

	match playerId:
		1:
			initial_width = player1_width[seat / 5]
		2:
			initial_width = player2_width[seat / 5]

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
