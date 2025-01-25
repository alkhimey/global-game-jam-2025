extends Node2D

@export var audience_scene: PackedScene
@export var inbetween_seconds: float = 0.3

var audience_count = [0, 0]

var seats = 14

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.player_win.connect(on_win)
	GameplayGlobal.goal.connect(on_goal)
	GameplayGlobal.game_reset.connect(on_game_reset)
	
	# Test for summoning audience
	# summon_audience(4, 1)
	# summon_audience(4, 2)


func on_win(playerId: int):
	if playerId > 0:
		summon_audience(1, playerId)


func on_goal(playerId: int):
	if playerId > 0:
		summon_audience(1, playerId)


func summon_audience(amount: int, player_num: int):
	for i in amount:
		# if audience_count[player_num - 1] >= max_audience:
		# 	break

		var audience_node = audience_scene.instantiate()
		add_child(audience_node)

		audience_node.seat = randi_range(0, seats - 1)

		# while 1 == 1:
		# 	audience_node.seat = randi_range(0, max_audience - 1)

		# 	if seats[player_num - 1][audience_node.seat] == true:
		# 		seats[player_num - 1][audience_node.seat] = false
		# 		audience_count[player_num - 1] += 1
		# 		break

		audience_node.change_player(player_num)

		await get_tree().create_timer(inbetween_seconds).timeout


func on_game_reset():
	var children := get_children()

	for i in children:
		i.queue_free()
