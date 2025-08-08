extends CharacterBody2D
class_name Key_Star_lvl2

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var enum_color := EColor.ENUM_COLOR.STAR

signal clicked
var held := false

var original_position := Vector2.ZERO

var disable := false :
	set(value):
		disable = value
		collision_shape_2d.set_deferred("disabled", value)
		visible = !value

func _ready():
	original_position = global_position

func reset():
	#print_debug("SALUTTTTTTTTT")
	print(global_position)
	# global_position = original_position
	print(global_position)
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


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)


func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()
