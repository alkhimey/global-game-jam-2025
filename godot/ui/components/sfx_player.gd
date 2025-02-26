extends AudioStreamPlayer

@export var hover_sound: AudioStream
@export var new_hover_sound: AudioStream
@export var click_sound: AudioStream
@export var pause_sound: AudioStream


func play_pause():
	stream = pause_sound
	play()


func play_hover():
	stream = hover_sound
	play()


func play_click():
	stream = click_sound
	play()


func play_hover_new():
	stream = new_hover_sound
	play()