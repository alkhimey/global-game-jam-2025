extends BaseButton

@onready var sfx_node = %SFX


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_hover)
	pressed.connect(on_press)


func on_hover():
	sfx_node.play_hover_new()


func on_press():
	sfx_node.play_click()
