extends Node

const countdown_time: float = 60  # Store as float for precise timing

# Player 1 score
var score1: int = 0
# Player 2 score
var score2: int = 0

# Player 1 wins
var wins1: int = 0
# Player 2 wins
var wins2: int = 0

# Current match time (currently managed on gameplay_overlay.gd)
# var time: int = 0

# Can a player currently goal - used inbetween goal and reset
var can_goal = true
# Game's score limit
var score_limit = 15
# Player Colors
var player_colors: Array = [Color.BLUE, Color.RED]


# Time to wait inbetween goal and reset in seconds
const goal_timeout = 2.0

# When player goals (playerId = which player)
signal goal(playerId:int)
# When players reset after a goal
signal goal_reset()
# When a certain player wins (playerId = which player)
signal player_win(playerId:int)
# When the match timer reaches 0
signal timer_end()
signal end_countdown()
signal game_reset()
signal scence_reset()
signal key_pressed()


func _ready():
	# Signal connections
	goal.connect(on_goal)
	timer_end.connect(on_timer_end)
	goal_reset.connect(on_goal_reset)
	player_win.connect(_on_player_win)
	game_reset.connect(on_game_reset)


func on_goal(playerId: int):
	# Making sure a player can't goal and move inbetween goal and reset
	#can_goal = false

	# Add a point to the scoring player
	if playerId == 1:
		score1 += 1
	else:
		score2 += 1

	# Wait inbetween goal and reset
	await get_tree().create_timer(goal_timeout).timeout

	# If both players didn't reach the score limit
	if score1 < score_limit && score2 < score_limit:
		# Reset player positions
		goal_reset.emit()
		return
	
	# When one of the players reaches the score limit, end the game
	print("game should end?")
	on_game_end()
		

# Reset player positions after a goal
func on_goal_reset():
	print("reset!!")
	#can_goal = true


# When the match timer reaches 0
func on_timer_end():
	print("timer ends")
	on_game_end()


# When the game ends either when the match timer reaches 0 
# or one of the players reaches the score limit
func on_game_end():
	can_goal = false

	if score1 > score2:
		player_win.emit(1)
		return
		
	if score2 > score1:
		player_win.emit(2)
		return
		
	player_win.emit(0)



# Show which player won
func _on_player_win(playerId: int):
	if playerId == 0:
		print("Game over: tie")
		
	print("Game over: P" + str(playerId) +" won")

	if playerId == 1:
		wins1 += 1
	elif playerId == 2:
		wins2 += 1

	await get_tree().create_timer(3.0).timeout
	await key_pressed

	game_reset.emit()
	scence_reset.emit()


func on_game_reset():
	score1 = 0
	score2 = 0


func _input(_event):
	if _event is not InputEventMouseMotion:
		key_pressed.emit()
