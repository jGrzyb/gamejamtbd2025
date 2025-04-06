extends Node2D

class_name MusicN

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var audio_stream_player_2d_3: AudioStreamPlayer2D = $AudioStreamPlayer2D3
@onready var audio_stream_player_2d_4: AudioStreamPlayer2D = $AudioStreamPlayer2D4
@onready var audio_stream_player_2d_5: AudioStreamPlayer2D = $AudioStreamPlayer2D5

func menu():
	if not audio_stream_player_2d.playing:
		audio_stream_player_2d.play()
	audio_stream_player_2d_2.stop()
	audio_stream_player_2d_3.stop()
	audio_stream_player_2d_4.stop()
	audio_stream_player_2d_5.stop()

func game():
	if not audio_stream_player_2d_2.playing:
		audio_stream_player_2d.stop()
	audio_stream_player_2d_2.play()

func win():
	audio_stream_player_2d_3.play()

func kill():
	audio_stream_player_2d_4.play()

func die():
	audio_stream_player_2d_5.play()
