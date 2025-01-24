extends Node2D

@onready var pause_overlay = %PauseOverlay
@onready var gameover_overlay = $CanvasLayer/GameoverOverlay


func _ready():
	GameplayGlobal.player_win.connect(on_game_over)


func on_game_over(_playerId: int):
	print("show gameover")
	get_viewport().set_input_as_handled()
	gameover_overlay.grab_button_focus()
	gameover_overlay.visible = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
