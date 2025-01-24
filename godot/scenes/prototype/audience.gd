extends Node2D

@export var audience_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.goal.connect(on_goal)

	summon_audience(4, 0)
	summon_audience(4, 1)


func on_goal(playerId: int):
	summon_audience(3, playerId - 1)


func summon_audience(amount: int, color_num: int):
	for i in amount:
		var audience_node = audience_scene.instantiate()
		audience_node.shirt_color = GameplayGlobal.player_colors[color_num]
		audience_node.change_shirt()

		add_child(audience_scene.instantiate())
