extends Area2D
class_name Mouse

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal clicked

@export var speed_x := 250
@export var speed_y := 250
@export var direction_x := 0
@export var direction_y := 0

var disable := false :
	set(value):
		disable = value
		collision_shape_2d.set_deferred("disabled", value)
		set_physics_process(!value)
		visible = !value

func reset():
	disable = false

func _physics_process(delta: float) -> void:
	position.x += direction_x * delta * speed_x
	position.y += direction_y * delta * speed_y

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
