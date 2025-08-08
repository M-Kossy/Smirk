extends CharacterBody2D

signal clicked

var original_position := Vector2.ZERO
var held := false
var time_between := 6000
var last_animation := Time.get_ticks_msec() + time_between
var rng : RandomNumberGenerator
var min_pos : Vector2
var max_pos : Vector2
var speed = 10

@export var go_up : bool = true
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
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
	held = false
	global_position = original_position

func touched_wall(pos):
	held = false
	global_position = pos


func drop():
	if held:
		held = false

func pickup():
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
