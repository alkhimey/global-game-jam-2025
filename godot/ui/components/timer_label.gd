extends Label

@export var countdown = true
@export var countdown_seconds = 60


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# initialize timer
	on_timer()

	# connect timer update signal to update text
	GameplayGlobal.timer_updated.connect(on_timer)


# when timer updates - update text
func on_timer():

	# calculate seconds
	var seconds_int = 0
	if countdown:
		seconds_int = (countdown_seconds - GameplayGlobal.time) % 60
	else:
		seconds_int = GameplayGlobal.time % 60
	var seconds_str = get_time_str(seconds_int)

	# calculate minutes
	var minutes_int = 0
	if countdown:
		minutes_int = (countdown_seconds - GameplayGlobal.time) / 60
	else:
		minutes_int = GameplayGlobal.time / 60
	var minutes_str = get_time_str(minutes_int)

	# concat final text
	text = minutes_str + ":" + seconds_str

	if countdown && seconds_int == 0 && minutes_int == 0:
		GameplayGlobal.timer_end.emit()


# get time string
func get_time_str(time: int):
	if time < 10:
		return "0" + str(time)
	else:
		return str(time)
