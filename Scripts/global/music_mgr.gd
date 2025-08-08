extends Node

enum MUSIC {MENU, GAME, GAME_SPEED_UP, UNDEFINED}

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var actual_music: MUSIC = MUSIC.UNDEFINED


func stop():
	actual_music = MUSIC.UNDEFINED
	audio_stream_player.stop()

func play(mus : MUSIC):
	if mus == actual_music:
		return
	if mus == MUSIC.MENU:
		audio_stream_player["parameters/switch_to_clip"] = "MENU"
		audio_stream_player.volume_db = 0.0
	elif mus == MUSIC.GAME:
		audio_stream_player["parameters/switch_to_clip"] = "GAME"
		audio_stream_player.volume_db = 0.0
	elif mus == MUSIC.GAME_SPEED_UP:
		audio_stream_player["parameters/switch_to_clip"] = "GAME_SPEED_UP"
		audio_stream_player.volume_db = -5.0
	
	if !audio_stream_player.playing:
		audio_stream_player.play()
	actual_music = mus
