extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "00:00"

	GameplayGlobal.timer_updated.connect(on_timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_timer():
	text = str(GameplayGlobal.time / 60) + ":" + str(GameplayGlobal.time % 60)
