extends Node2D

@onready var pause_overlay = %PauseOverlay
@onready var gameover_overlay = $CanvasLayer/GameoverOverlay
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var levelTimer: Timer
@export var goal: Node2D

var currentGoalPositionPreset = 0
var goalPositionPresets: Array
var nextGoalPositionWhenTimeLeft: Array 

func _ready():
	GameplayGlobal.player_win.connect(on_game_over)
	GameplayGlobal.scence_reset.connect(_on_scence_restart)
	GameplayGlobal.game_reset.emit()

	levelTimer = $CanvasLayer/GameplayOverlay/LevelTimer

	goalPositionPresets = [
		goal.position,
		Vector2(randf_range(200, 600),randf_range(160, 250)),
		Vector2(randf_range(200, 600), randf_range(160, 250))
	]
	
	#x = 600 - 200
	#y = 160 -250
	
	nextGoalPositionWhenTimeLeft = [
		(GameplayGlobal.countdown_time * 2.0) / 3.0,
		GameplayGlobal.countdown_time / 3.0
	]

func _process(delta: float) -> void:
	if not levelTimer.is_stopped():
		if currentGoalPositionPreset < goalPositionPresets.size() - 1:
			if levelTimer.time_left < nextGoalPositionWhenTimeLeft[currentGoalPositionPreset]:
				currentGoalPositionPreset += 1
				var tween = get_tree().create_tween()
				tween.tween_property(goal, "position", goalPositionPresets[currentGoalPositionPreset], 1)
			

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
		
func _on_scence_restart():
	print("Game resetting...")  # Debugging
	if get_tree():
		get_tree().reload_current_scene()
	else:
		print("Error: get_tree() is null")
