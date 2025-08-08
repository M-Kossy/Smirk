extends CharacterBody2D
class_name Key_lvl2

signal clicked

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var enum_color : EColor.ENUM_COLOR = EColor.ENUM_COLOR.HEART

var original_position := Vector2.ZERO
var original_rotation := 0.0

var held := false
var disable := false :
	set(value):
		disable = value
		collision_shape_2d.set_deferred("disabled", value)
		visible = !value


func _ready() -> void:
	original_position = global_position
	original_rotation = rotation
	draw_sprite()

func draw_sprite():
	var index := 0
	match enum_color:
		EColor.ENUM_COLOR.DIAMOND:
			index = 0
		EColor.ENUM_COLOR.SPADE:
			index = 3
		EColor.ENUM_COLOR.HEART:
			index = 2
		EColor.ENUM_COLOR.CLUB:
			index = 1
	sprite_2d.region_rect.position.x = index * sprite_2d.region_rect.size.x
	
func set_sprite(e_color : EColor.ENUM_COLOR):
	enum_color = e_color
	draw_sprite()
	
func reset():
	global_position = original_position
	draw_sprite()
	disable = false

func drop():
	if held:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DROP_KEY)
		held = false

func pickup():
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.PICK_UP)
	if held:
		return
	move_to_front()
	held = true

func set_key_rotation(rot : int):
	rotation = rot + original_rotation

func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
