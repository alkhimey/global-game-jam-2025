extends Control

@export var LevelTime: Timer
@export var timerLabel: Label

func _ready() -> void:
	start_level_timer()
	

func start_level_timer() -> void:
	LevelTime.wait_time = GameplayGlobal.countdown_time
	LevelTime.timeout.connect(_on_level_timer_timeout)

	await GameplayGlobal.end_countdown

	LevelTime.start()
	update_label()

func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)  # Get two-digit ms

	if LevelTime.time_left < 10:
		return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
	else:
		return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _process(_delta: float) -> void:
	# if countdown_time > 0:
	# 	countdown_time -= delta
	# 	if countdown_time < 0:
	# 		countdown_time = 0
	update_label()

func update_label() -> void:
	timerLabel.text = format_time(LevelTime.time_left)


func _on_level_timer_timeout() -> void:
	update_label()
	print("Level time is done")
	timerLabel.text = "Time's up!"
	GameplayGlobal.timer_end.emit()
