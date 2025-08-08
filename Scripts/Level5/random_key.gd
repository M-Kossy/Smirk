extends CharacterBody2D
class_name Randomkey

signal clicked

@onready var random_key_sprite: Sprite2D = $Random_key_sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var enum_index:int
var original_position := Vector2.ZERO
var held := false
var disable := false :
	set(value):
		disable = value
		collision_shape_2d.set_deferred("disabled", value)
		visible = !value
var time_between := 6000
var rng : RandomNumberGenerator
var min_pos : Vector2
var max_pos : Vector2
var speed = 10

@export var go_up : bool = true


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	time_between = rng.randi_range(4000, 15000)
	enum_index = random_key_sprite.enum_color
	original_position = global_position
	
	if go_up:
		min_pos = Vector2(random_key_sprite.position.x, random_key_sprite.position.y - 10)
		max_pos = random_key_sprite.position
		random_key_sprite.position.y += rng.randi_range(-10, 0)
	else:
		min_pos = random_key_sprite.position
		max_pos = Vector2(random_key_sprite.position.x, random_key_sprite.position.y + 10)
		random_key_sprite.position.y += rng.randi_range(0, 10)

func reset_pos():
	global_position = original_position

func reset():
	global_position = original_position
	disable = false

func drop():
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DROP_KEY)
	if held:
		held = false

func pickup():
	if held:
		return
	held = true

func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()
	else:
		if go_up:
			random_key_sprite.position.y = clamp(random_key_sprite.position.y - delta * speed, min_pos.y, max_pos.y)
			if(random_key_sprite.position.y <= min_pos.y):
				go_up = false
		else:
			random_key_sprite.position.y = clamp(random_key_sprite.position.y + delta * speed, min_pos.y, max_pos.y)
			if(random_key_sprite.position.y >= max_pos.y):
				go_up = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
