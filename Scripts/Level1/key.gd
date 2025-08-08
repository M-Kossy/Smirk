extends CharacterBody2D
class_name Key

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

signal clicked
var held := false
var time_between := 6000
var rng : RandomNumberGenerator
var min_pos : Vector2
var max_pos : Vector2
var speed = 10

var original_position := Vector2.ZERO

@export var go_up : bool = true

var disable := false :
	set(value):
		disable = value
		collision_shape_2d.set_deferred("disabled", value)
		visible = !value

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	time_between = rng.randi_range(4000, 15000)
	original_position = global_position

	if go_up:
		min_pos = Vector2(sprite_2d.position.x, sprite_2d.position.y - 10)
		max_pos = sprite_2d.position
		sprite_2d.position.y += rng.randi_range(-10, 0)
	else:
		min_pos = sprite_2d.position
		max_pos = Vector2(sprite_2d.position.x, sprite_2d.position.y + 10)
		sprite_2d.position.y += rng.randi_range(0, 10)

func reset():
	global_position = original_position
	disable = false

func drop():
	if held:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DROP_KEY)
		held = false

func pickup():
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PICK_UP)
	if held:
		return
	held = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)


func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()
	else:
		if go_up:
			sprite_2d.position.y = clamp(sprite_2d.position.y - delta * speed, min_pos.y, max_pos.y)
			if(sprite_2d.position.y <= min_pos.y):
				go_up = false
		else:
			sprite_2d.position.y = clamp(sprite_2d.position.y + delta * speed, min_pos.y, max_pos.y)
			if(sprite_2d.position.y >= max_pos.y):
				go_up = true
