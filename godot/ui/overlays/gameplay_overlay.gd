extends Control

# Timer to update the timer label
@export var textUpdateTimer: Timer
# Match timer
@export var LevelTime: Timer
# Timer label
@export var timerLabel: Label

# Countdown time in seconds
var countdown_time: int = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start the level timer
	start_level_timer()

	# Connect the textUpdateTimer timeout to update the label
	textUpdateTimer.timeout.connect(_on_textUpdateTimer_timeout)
	textUpdateTimer.start()

func start_level_timer() -> void:
	# Set the LevelTime duration and connect its timeout
	LevelTime.wait_time = countdown_time
	LevelTime.timeout.connect(_on_level_timer_timeout)
	LevelTime.start()

	# Ensure the label shows the initial time
	update_label()

func format_time(time: int) -> String:
	# Format time as mm:ss
	var minutes = time / 60
	var seconds = time % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _on_textUpdateTimer_timeout() -> void:
	# Decrease the countdown time
	if countdown_time > 0:
		countdown_time -= 1
		update_label()
		print("Time remaining: " + str(countdown_time) + " seconds")
	else:
		# Stop the textUpdateTimer when time runs out
		textUpdateTimer.stop()

func update_label() -> void:
	# Update the timerLabel text with the formatted time
	timerLabel.text = format_time(countdown_time)

func _on_level_timer_timeout() -> void:
	# Triggered when the LevelTime timer finishes
	print("Level time is done")
	timerLabel.text = "Time's up!"
	textUpdateTimer.stop()
	GameplayGlobal.timer_end.emit()
