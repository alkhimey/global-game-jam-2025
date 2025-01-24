extends Node2D

@export var audience_scene: PackedScene
@export var inbetween_seconds: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.player_win.connect(on_win)

	summon_audience(4, 1)
	summon_audience(4, 2)


func on_win(playerId: int):
	if playerId > 0:
		summon_audience(3, playerId - 1)


func summon_audience(amount: int, player_num: int):
	for i in amount:
		var audience_node = audience_scene.instantiate()

		add_child(audience_node)
		audience_node.change_player(player_num)

		await get_tree().create_timer(inbetween_seconds).timeout
