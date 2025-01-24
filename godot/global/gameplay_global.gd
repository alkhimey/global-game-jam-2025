extends Node

var score1: int = 0
var score2: int = 0
var time: int = 0

signal goal(playerId:int)
signal goal_reset()
signal player_win(playerId:int)

func _ready():
	goal.connect(on_goal)
	goal_reset.connect(on_goal_reset)
	player_win.connect(_on_player_win)


func on_goal(playerId: int):
	if playerId == 1: 
		score1 += 1
	else:
		score2 += 1

	await get_tree().create_timer(2.0).timeout

	if score1 < 3 && score2 < 3:
		goal_reset.emit()
		return
	
	print("game should end?")
	on_timer_end()
		

func on_goal_reset():
	print("reset!!")
	pass


func on_timer_end():
	if score1 > score2:
		player_win.emit(1)
		return
		
	if score2 > score1:
		player_win.emit(2)
		return
		
	player_win.emit(0)

func _on_player_win(playerId: int):
	if playerId == 0: 
		print("Game over: tie")
		return
		
	print("Game over: P" + str(playerId) +" won")
