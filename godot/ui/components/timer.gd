extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_timeout():
	pass
