extends Action 


var held_object : CharacterBody2D = null
var disabled := true
var ice_number :int
var ice_number_start:int

@onready var ice: Area2D = $Ice
@onready var star_button: Area2D = $Star_button

func start():
	ice_number = ice_number_start
	star_button.reset()
	ice.reset()

func _ready() -> void:
	action_name = "Break_the_ice"
	ice_number_start = 0
	for node in get_children():
		if node.is_in_group("Ice"):
			ice_number_start += 1
			node.ice_destroy.connect(ice_count)

func enable():
	disabled = false
	star_button.set_deferred("disable", false)
	ice.set_deferred("disable", false)

func disable():
	disabled = true
	star_button.collision_shape_2d.set_deferred("disabled", true)
	ice.collision_shape_2d.set_deferred("disabled", true)

func ice_count():
	ice_number -= 1

func _on_star_button_button_clicked() -> void:
	if ice_number <= 0:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.BUTTON)
		is_done()
