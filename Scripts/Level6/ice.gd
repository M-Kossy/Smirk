extends Area2D

signal ice_destroy

var clicks: int = 40
var original_position := Vector2.ZERO

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cube: Sprite2D = $Cube

func _ready():
	original_position = global_position

func reset():
	animated_sprite_2d.frame = 0
	cube.visible = true
	clicks = 40
	global_position = original_position
	collision_shape_2d.set_deferred("disabled", false)
	visible = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.HAMMER_HIT)
			cpu_particles_2d.emitting = true
			animation_player.play("Shake")
			clicks -= 1 
		match clicks:
			40:
				animated_sprite_2d.frame = 0
			32:
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
				animated_sprite_2d.frame = 1
			24:
				animated_sprite_2d.frame = 2
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
			16:
				animated_sprite_2d.frame = 3
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
			8:
				animated_sprite_2d.frame = 4
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
			0:
				SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.GLASS_BREAK)
				ice_destroy.emit()
				cube.visible = false
				visible = false
				collision_shape_2d.disabled = true
