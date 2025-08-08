extends Action

@export var speed_projectile := 1200.0
@export var time_timer := 1

@onready var cibles: Node2D = $Cibles
@onready var ball: CharacterBody2D = $ball
@onready var timer: Timer = $Timer
@onready var canon: Sprite2D = $canon

var fired := false
var count := 0
var activated := false


func _ready() -> void:
	action_name = "Bad_aim"
	for cible in cibles.get_children():
		cible.on_touch.connect(_on_touch)
	
	timer.wait_time = time_timer
	fired = false
	count = 0
	ball.set_physics_process(false)
	ball.visible = false


func start():
	fired = false
	count = 0
	ball.set_physics_process(false)
	ball.visible = false
	for cible in cibles.get_children():
		cible.reset()


func _on_touch(cible : Node2D, body : Node2D):
	if body == ball:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.HIT)
		cible.disable = true
		timer.stop()
		fired = false
		ball.set_physics_process(false)
		ball.visible = false
		ball.global_position = canon.global_position + Vector2(50.0, 0.0)
		count += 1
		
		if count >= cibles.get_child_count():
			is_done()


func _process(delta: float) -> void:
	canon.look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !fired and activated:
			SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.SHOOT)
			var direction = (get_global_mouse_position() - canon.global_position).normalized()
			var texture_canon := canon.texture
			var spawn_position = canon.global_position + direction * (texture_canon.get_width()/2 - 150)
			
			ball.global_position = spawn_position
			
			fired = true
			ball.visible = true
			
			ball.rotation = direction.angle()
			ball.velocity = direction * speed_projectile * scale
			
			ball.set_physics_process(true)
			timer.start()


func _on_timer_timeout() -> void:
	fired = false
	ball.set_physics_process(false)
	ball.visible = false


func enable():
	activated = true


func disable():
	activated = false
