extends Area2D



func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)
	
	

func _on_area_2d_body_entered(body: Node):
	print("body enterd")
	##add score +1 to global
