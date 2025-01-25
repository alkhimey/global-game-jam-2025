extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(on_music_finished)

func on_music_finished():
	stream_paused = false