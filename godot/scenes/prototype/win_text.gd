extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.player_win.connect(on_gameover)
	GameplayGlobal.game_reset.connect(on_game_start)


func on_game_start():

	text = "[center][color=black][shake rate=20.0 level=4]7"
	GameplayGlobal.can_goal = false
	visible = true

	await get_tree().create_timer(1.2).timeout

	text = "[center][color=black][shake rate=20.0 level=5]6"

	await get_tree().create_timer(1.2).timeout

	text = "[center][color=black][shake rate=20.0 level=6]5"

	await get_tree().create_timer(1.2).timeout

	text = "[center][color=black][shake rate=20.0 level=7]4"

	await get_tree().create_timer(1.2).timeout

	text = "[center][color=black][shake rate=20.0 level=8]3"

	await get_tree().create_timer(0.4).timeout

	text = "[center][color=black][shake rate=20.0 level=9]2"

	await get_tree().create_timer(0.4).timeout

	text = "[center][color=black][shake rate=20.0 level=15]1"

	await get_tree().create_timer(1.2).timeout

	text = "[rainbow][center][wave]GO!"
	GameplayGlobal.can_goal = true
	GameplayGlobal.end_countdown.emit()

	await get_tree().create_timer(0.5).timeout

	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_gameover(playerId: int) -> void:
	match playerId:
		1:
			text = "[tornado freq=3.0][rainbow val=0.8]Player 1 Wins!!!!!![tornado]"
		2:
			text = "[tornado freq=3.0][rainbow val=0.8]Player 2 Wins!!!!!![tornado]"
		0:
			text = "[tornado freq=3.0][rainbow val=0.8]It's a tie!!!![tornado]"

	visible = true
