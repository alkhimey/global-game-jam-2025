extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "0 : 0"

	GameplayGlobal.goal.connect(on_goal)


func on_goal(_is_player_1: bool):
	text = str(GameplayGlobal.score1) + " : " + str(GameplayGlobal.score2)