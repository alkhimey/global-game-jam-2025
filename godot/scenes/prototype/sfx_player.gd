extends AudioStreamPlayer


@export var goal_stream: AudioStream
@export var start_stream: AudioStream


func _ready() -> void:
	GameplayGlobal.goal.connect(play_goal)


func play_goal(_playerId: int):
	stream = goal_stream
	play()


func start_play():
	stream = start_stream
	play()