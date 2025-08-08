extends Node2D

enum {DEBUT, MID, END}

var can_click := true

var actions : Array[Action] = []
var current_action_index := 0
var current_action : Action = null
var duration: int
var smirk_state: String
var amplitude:= 1.5
var speed_rotation:= 2.0
var time := 0.0
var mouse_open_hand = load("res://Assets/Sprites/MOUSE/open.png")
var mouse_closed_hand = load("res://Assets/Sprites/MOUSE/ferme.png")
var mouse_hammer = load("res://Assets/Sprites/MOUSE/marteau.png")
var mouse_poiting = load("res://Assets/Sprites/MOUSE/point.png")
var winning = false

@export var start_index := 0
@onready var lbl_time_left: Label = $mid/Lbl_time_left
@onready var end_timer: Timer = $mid/End_timer
@onready var smirk_timer: Timer = $mid/Smirk_timer
@onready var smirk: AnimatedSprite2D = $mid/Smirk
@onready var transition: AnimationPlayer = $mid/Transition
@onready var level_number: AnimationPlayer = $mid/Level_number
@onready var ending: AnimationPlayer = $end/Ending
@onready var music_timer: Timer = $mid/music_timer
@onready var deg_happy_happypng: Sprite2D = $end/Deg_happyHappypng
@onready var ok: Sprite2D = $end/Ok

var state := DEBUT

var initial_start_index := 0

func _ready() -> void:
	state = DEBUT
	set_process(false)
	$mid.visible = false
	$debut.visible = false
	$end.visible = false
	reset_and_start()

func reset_and_start():
	if state == DEBUT:
		start_debut()
	elif state == MID:
		start_mid()
	elif state == END:
		start_end()

func start_debut():
	$debut.visible = true
	MusicMgr.play(MusicMgr.MUSIC.MENU)
	$end.visible = false

func start_end():
	deg_happy_happypng.visible = false
	ok.visible = false
	if winning == true:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.WIN)
		ok.visible = true
		ending.play("WIN")
	else:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GAME_OVER)
		deg_happy_happypng.visible = true
		ending.play("Game_over")
	$end.visible = true
	can_click = false
	await ending.animation_finished
	can_click = true
	$mid.visible = false


func start_mid():
	winning = false
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.WELCOME)
	$debut.visible = false
	$mid.visible = true
	MusicMgr.play(MusicMgr.MUSIC.GAME)
	Input.set_custom_mouse_cursor(mouse_open_hand,0,Vector2(32,24))
	transition.play('Curtain_open')
	await transition.animation_finished
	for node in $mid.get_children():
		if node is Action:
			if actions.find(node) == -1:
				actions.push_back(node)
			node.disable()
			node.visible = false
	
	initial_start_index = start_index
	
	if start_index >= actions.size():
		start_index = actions.size()-1
	elif start_index < 0:
		start_index = 0

	current_action_index = start_index
	set_current_action()
	end_timer.start()
	music_timer.start()
	set_process(true)


func _process(delta):
	lbl_time_left.text = converting_time(end_timer.time_left, true)
	
	if current_action:
		current_action.update(delta)
	 
	smirk.rotation_degrees = sin(time) * amplitude


func _input(event: InputEvent) -> void:
	match current_action_index:
		0, 2 , 3, 4:
			if event.is_action_pressed("LEFT_MOUSE"):
				Input.set_custom_mouse_cursor(mouse_closed_hand,0,Vector2(8,8))
			if event.is_action_released("LEFT_MOUSE"):
				Input.set_custom_mouse_cursor(mouse_open_hand,0,Vector2(8,8))
		5:
			Input.set_custom_mouse_cursor(mouse_hammer,0,Vector2(32,24))
		1,6:
			Input.set_custom_mouse_cursor(mouse_poiting,0,Vector2(0,0))


func _on_sequence_done():
	start_index += 1
	if start_index < actions.size():
		current_action_index = start_index
		set_current_action()
		end_timer.start()
		music_timer.start()
		MusicMgr.play(MusicMgr.MUSIC.GAME)
	else:
		winning = true
		end_timer.stop()
		music_timer.stop()
		state = END
		current_action.done.disconnect(on_done)
		current_action.disable()
		current_action.visible = false
		start_index = initial_start_index
		current_action_index = start_index
		reset_and_start()


func on_done():
	current_action_index -= 1
	current_action.done.disconnect(on_done)
	current_action.disable()
	if current_action_index > -1:
		smirk_state = "sad"
		changing_smirk()
		transition.play("Drawer_close")
		match current_action_index:
			0:
				level_number.play("Key_is_lava")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.THE_KEY_IS_LAVA)
			1:
				level_number.play("Bad_aim")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BAD_AIM)
			2:
				level_number.play("Find_the_star")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DO_NOT_FIND)
			3:
				level_number.play("Touch_the_wall")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.TOUCH_THE_WALL)
			4:
				level_number.play("Pair")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DO_NOT_MAKE)
			5:
				level_number.play("Break_the_ice")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DO_NOT_BREAK)
			6:
				level_number.play("In_the_light")
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.STAY_IN_THE_LIGHT)
		end_timer.paused = true
		music_timer.paused = true
		await transition.animation_finished
		current_action.visible = false
		transition.play("Drawer_open")
		end_timer.paused = false
		music_timer.paused = false
		set_current_action()
	else:
		SfxManager.create_audio_loser()
		smirk_state = "sad"
		changing_smirk()
		transition.play("Curtain_close")
		level_number.play("Too_easy")
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.CURTAIN)
		end_timer.paused = true
		music_timer.paused = true
		await transition.animation_finished
		current_action.visible = false
		transition.play("Curtain_open")
		end_timer.paused = false
		music_timer.paused = false
		_on_sequence_done()


func set_current_action():
	smirk_state = "happy"
	changing_smirk()
	current_action = actions[current_action_index]
	current_action.start()
	current_action.done.connect(on_done)
	current_action.enable()
	current_action.visible = true


func _on_end_timer_timeout() -> void:
	state = END
	current_action.done.disconnect(on_done)
	current_action.disable()
	current_action.visible = false
	start_index = initial_start_index
	current_action_index = start_index
	reset_and_start()


func _on_smirk_timer_timeout() -> void:
	changing_smirk()


func converting_time(time:float, use_milliseconds: bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time,60)
	
	if not use_milliseconds:
		return "%02d" % [seconds]
	
	var milliseconds := fmod(time, 1) *100
	
	return "%02d:%02d" % [seconds, milliseconds]


func changing_smirk():
	randomize()
	var random_index_happy = randi_range(0, 10)
	randomize()
	var random_index_sad = randi_range(11, 20)
	match smirk_state:
		"happy":
			smirk_timer.paused = true
			smirk.frame = random_index_happy
		"sad":
			smirk_timer.paused = false
			smirk_timer.start(2)
			smirk.frame = random_index_sad


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_click:
			if state == DEBUT:
				state = MID
				reset_and_start()
			elif state == END:
				state = DEBUT
				reset_and_start()


func _on_music_timer_timeout() -> void:
	MusicMgr.play(MusicMgr.MUSIC.GAME_SPEED_UP)
