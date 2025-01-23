extends Node

var score1: int = 0
var score2: int = 0
var time: int = 0

signal goal(is_player_1: bool)
signal goal_reset()
signal timer()
signal timer_updated()
signal player_win(is_player_1: bool)
signal game_tie()
signal timer_end()


func _ready():
	goal.connect(on_goal)
	goal_reset.connect(on_goal_reset)
	timer.connect(on_timer)


func on_goal(is_player_1: bool):

	if is_player_1:
		score1 += 1
	else:
		score2 += 1

	await get_tree().create_timer(2.0).timeout

	if score1 < 5 && score2 < 5:
		goal_reset.emit()
	elif score1 >= 5:
		player_win.emit(true)
	elif score2 >= 5:
		player_win.emit(false)


func on_goal_reset():
	pass


func on_timer():
	time += 1
	timer_updated.emit()


func on_timer_end():

	if score1 > score2:
		player_win.emit(true)
	elif score2 > score1:
		player_win.emit(false)
	else:
		game_tie.emit()