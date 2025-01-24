extends AudioStreamPlayer2D


@export var jump_stream: AudioStream
@export var curse_stream_l: AudioStream
@export var curse_stream_s: AudioStream


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func play_jump():
	stream = jump_stream
	play()


func play_curse(playerId: int):
	match playerId:
		1:
			stream = curse_stream_l
		2:
			stream = curse_stream_s

	play()