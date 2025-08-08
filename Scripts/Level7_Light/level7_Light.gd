extends Action

@onready var left_button: Area2D = $Button/Left_Button
@onready var up_button: Area2D = $Button/Up_Button
@onready var down_button: Area2D = $Button/Down_Button
@onready var right_button: Area2D = $Button/Right_Button

@onready var spot_lights: Node2D = $SpotLights

@onready var end: Area2D = $End
@onready var end_collision_shape_2d: CollisionShape2D = $End/CollisionShape2D

@onready var little_ch: CharacterBody2D = $little_ch
@onready var little_ch_collision_shape_2d: CollisionShape2D = $little_ch/CollisionShape2D

@export var speed := 200.0;

var disabled := false

var original_position_little_ch := Vector2.ZERO

var horizontal := 0
var vertical := 0

func _ready() -> void:
	action_name = "In_the_light"
	down_button.clicked.connect(_on_down)
	right_button.clicked.connect(_on_right)
	left_button.clicked.connect(_on_left)
	up_button.clicked.connect(_on_up)
	end.body_entered.connect(_on_end)
	
	original_position_little_ch = little_ch.global_position
	
	for light in spot_lights.get_children():
		light.on_light.connect(_on_light)

func start():
	little_ch.global_position = original_position_little_ch

func _physics_process(delta: float) -> void:
	little_ch.position.x += horizontal * delta * speed
	little_ch.position.y += vertical * delta * speed


func _on_light(body):
	if body == little_ch:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.WALL_FAIL)
		little_ch.global_position = original_position_little_ch
		vertical = 0
		horizontal = 0

func _on_end(body : Node2D):
	if body == little_ch:
		little_ch.global_position = original_position_little_ch
		is_done()

func _on_right(b : bool):
	if disabled:
		return

	if b:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON)
		horizontal = 1
	else:
		horizontal = 0

func _on_left(b : bool):
	if disabled:
		return

	if b:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON)
		horizontal = -1
	else:
		horizontal = 0

func _on_up(b : bool):
	if disabled:
		return

	if b:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON)
		vertical = -1
	else:
		vertical = 0

func _on_down(b : bool):
	if disabled:
		return
		
	if b:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON)
		vertical = 1
	else:
		vertical = 0


func enable():
	little_ch_collision_shape_2d.set_deferred("disabled", false)
	end_collision_shape_2d.set_deferred("disabled", false)
	for light in spot_lights.get_children():
		light.is_activated(true)
	disabled = false

func disable():
	little_ch_collision_shape_2d.disabled = true
	end_collision_shape_2d.disabled = true
	vertical = 0
	horizontal = 0
	for light in spot_lights.get_children():
		light.is_activated(false)
	disabled = true
