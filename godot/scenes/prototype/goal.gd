extends Area2D



func _ready() -> void:
	area_entered.connect(_on_area_endterd)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_endterd(area: Area2D):
	print("Goal")
	#add_score_func
