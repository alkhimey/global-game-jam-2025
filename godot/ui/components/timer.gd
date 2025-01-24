extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(on_timeout)


func on_timeout():
	GameplayGlobal.timer.emit()
