extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayGlobal.game_reset.connect(on_new_game)

func on_new_game():
	seek(0)
