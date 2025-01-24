extends CenterContainer

signal game_exited

@onready var new_button := %NewButton
@onready var settings_button := %SettingsButton
@onready var exit_button := %ExitButton
@onready var settings_container := %SettingsContainer
@onready var menu_container := %MenuContainer
@onready var back_button := %BackButton
@onready var title_label := %TitleLabel


func _ready() -> void:
	new_button.pressed.connect(_new)
	settings_button.pressed.connect(_settings)
	exit_button.pressed.connect(_exit)
	back_button.pressed.connect(_gameover_menu)
	GameplayGlobal.player_win.connect(on_player_win)
	

func grab_button_focus() -> void:
	new_button.grab_focus()
	

func _new() -> void:
	get_tree().paused = false
	visible = false
	GameplayGlobal.reset_game.emit()
	
	
func _settings() -> void:
	menu_container.visible = false
	settings_container.visible = true
	back_button.grab_focus()
	

func _exit() -> void:
	game_exited.emit()
	get_tree().quit()
	

func _gameover_menu() -> void:
	settings_container.visible = false
	menu_container.visible = true
	settings_button.grab_focus()
	

func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		get_viewport().set_input_as_handled()
		# if menu_container.visible:
		# 	_resume()
		if settings_container.visible:
			_gameover_menu()


func on_player_win(playerId: int):
	if playerId > 0:
		title_label.text = "player" + str(playerId) + "_wins"
	else:
		title_label.text = "game_tie"

	settings_container.visible = false
	menu_container.visible = true
	new_button.grab_focus()
