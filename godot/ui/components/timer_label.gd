extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# default text
	text = "00:00"

	# connect timer update signal to update text
	GameplayGlobal.timer_updated.connect(on_timer)


# when timer updates - update text
func on_timer():
	# calculate seconds
	var seconds_int = GameplayGlobal.time % 60
	var seconds_str = get_time_str(seconds_int)

	# calculate minutes
	var minutes_int = GameplayGlobal.time / 60
	var minutes_str = get_time_str(minutes_int)

	# concat final text
	text = minutes_str + ":" + seconds_str


# get time string
func get_time_str(time: int):
	if time < 10:
		return "0" + str(time)
	else:
		return str(time)
