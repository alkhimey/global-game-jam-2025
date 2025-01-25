extends Node2D

@onready var pause_overlay = %PauseOverlay
@onready var gameover_overlay = $CanvasLayer/GameoverOverlay
@onready var music_player: AudioStreamPlayer = $MusicPlayer

@export var levelTimer: Timer
@export var goal: Node2D

var currentGoalPositionPreset = 0
var goalPositionPresets: Array
var nextGoalPositionWhenTimeLeft: Array 

func _ready():
	GameplayGlobal.player_win.connect(on_game_over)

	goalPositionPresets = [
		goal.position,
		Vector2(210,228),
		Vector2(678, 261)
	]
	
	nextGoalPositionWhenTimeLeft = [
		(GameplayGlobal.countdown_time * 2.0) / 3.0,
		GameplayGlobal.countdown_time / 3.0
	]

func _process(delta: float) -> void:
	if currentGoalPositionPreset < goalPositionPresets.size() - 1:
		if levelTimer.time_left < nextGoalPositionWhenTimeLeft[currentGoalPositionPreset]:
			currentGoalPositionPreset += 1
			var tween = get_tree().create_tween()
			tween.tween_property(goal, "position", goalPositionPresets[currentGoalPositionPreset], 1)
			
	
	GameplayGlobal.game_reset.emit()

func on_game_over(_playerId: int):
	print("show gameover")
	# get_viewport().set_input_as_handled()
	# gameover_overlay.grab_button_focus()
	# gameover_overlay.visible = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
