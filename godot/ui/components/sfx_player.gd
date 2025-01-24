extends AudioStreamPlayer

@export var hover_sound: AudioStream
@export var click_sound: AudioStream


func play_hover():
	stream = hover_sound
	play()


func play_click():
	stream = click_sound
	play()