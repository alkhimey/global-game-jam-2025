extends Label

@export var playerId: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_goal(0)
	GameplayGlobal.goal.connect(on_goal)

func on_goal(_playerId: int):
	if playerId == 1:
		self.text = str(GameplayGlobal.score1)
	else:
		self.text = str(GameplayGlobal.score2)
