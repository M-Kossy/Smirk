extends Resource

class_name SoundEffectSettings

enum SOUND_EFFECT_TYPE{
	WIN,
	GAME_OVER,
	DO_NOT_BREAK,
	DO_NOT_FIND,
	DO_NOT_MAKE,
	DO_NOT_TOUCH,
	BAD_AIM,
	TOUCH_THE_WALL,
	DROP_KEY,
	KEY_OPEN,
	SHOOT,
	HIT,
	GLASS_BREAK,
	HAMMER_HIT,
	WALL_FAIL,
	PICK_UP,
	CURTAIN,
	BUTTON,
	THE_KEY_IS_LAVA,
	STAY_IN_THE_LIGHT,
	DO_IT_AGAIN,
	TOO_EASY,
	WELCOME,
	SMIRK
}

@export_range (0,10) var limit : int = 5
@export var type:SOUND_EFFECT_TYPE
@export var sound_effect : AudioStreamWAV
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0, .01) var pitch_scale = 1.0
@export_range(0.0, 1.0, .01) var pitch_randomness = 0.0


var audio_count = 0

func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)
	
func has_open_limit() -> bool:
	return audio_count < limit

func on_audio_finished():
	change_audio_count(-1)
