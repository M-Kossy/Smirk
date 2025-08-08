extends Area2D
class_name Door

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var original_position := Vector2.ZERO

signal door_open

func _ready():
	original_position = global_position

func reset():
	global_position = original_position
	collision_shape_2d.set_deferred("disabled", false)
	visible = true

func _on_body_entered(body: Node2D) -> void:
	if body is Key:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.KEY_OPEN)
		visible = false
		collision_shape_2d.disabled = true
		body.disable = true
		body.global_position += Vector2(sprite_2d.texture.get_width(), sprite_2d.texture.get_height())
		door_open.emit()
