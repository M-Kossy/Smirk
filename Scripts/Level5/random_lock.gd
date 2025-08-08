extends Area2D

signal open

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var lock_random_sprite: Sprite2D = $Lock_random_sprite
@onready var enum_index: int

signal unlock

var original_position := Vector2.ZERO


func get_level_index(order: int):
	enum_index = get_parent().index[order]
	lock_random_sprite.choose_sprite()


func _ready():
	original_position = global_position


func reset():
	global_position = original_position
	collision_shape_2d.set_deferred("disabled", false)
	visible = true


func _on_body_entered(body: Node2D) -> void:
	if body is Randomkey:
		if body.enum_index == enum_index:
			SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.KEY_OPEN)
			visible = false
			collision_shape_2d.disabled = true
			body.disable = true
			body.global_position += Vector2(lock_random_sprite.texture.get_width(), lock_random_sprite.texture.get_height())
			unlock.emit()
