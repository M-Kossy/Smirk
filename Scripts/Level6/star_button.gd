extends Area2D

signal button_clicked

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var original_position := Vector2.ZERO

func reset():
	global_position = original_position
	collision_shape_2d.set_deferred("disabled", false)
	visible = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("LEFT_MOUSE"):
		button_clicked.emit()
