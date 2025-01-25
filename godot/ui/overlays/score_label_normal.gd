extends Label

@export var playerId: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_goal(0)
	GameplayGlobal.goal.connect(on_goal)

func on_goal(_playerId: int):
	if _playerId == playerId:
		var origScale = self.scale
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3)
		tween.tween_property(self, "scale", origScale, 0.3)

	if playerId == 1:
		self.text = str(GameplayGlobal.score1)
	else:
		self.text = str(GameplayGlobal.score2)
		
