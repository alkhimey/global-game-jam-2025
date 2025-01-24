extends Node2D

@export var audience_scene: PackedScene
@export var inbetween_seconds: float = 0.1
@export var max_audience: int = 10

var audience_count = [0, 0]

var seats = [[false, false, false, false, false, false, false, false, false, false], 
			[false, false, false, false, false, false, false, false, false, false]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.player_win.connect(on_win)
	GameplayGlobal.goal.connect(on_goal)

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
		if audience_count[player_num - 1] >= max_audience:
			break

		var audience_node = audience_scene.instantiate()
		add_child(audience_node)

		while 1 == 1:
			audience_node.seat = randi_range(0, seats[player_num - 1].size() - 1)

			if not seats[player_num - 1][audience_node.seat]:
				seats[player_num - 1][audience_node.seat] = true
				audience_count[player_num - 1] += 1
				break

		audience_node.change_player(player_num)

		await get_tree().create_timer(inbetween_seconds).timeout
