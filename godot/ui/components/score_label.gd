extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_goal(0)

	GameplayGlobal.goal.connect(on_goal)


func on_goal(playerId: int):
	text = "[color=blue]" + str(GameplayGlobal.score1) + "[/color]:[color=red]" + str(GameplayGlobal.score2) + "[/color]"
