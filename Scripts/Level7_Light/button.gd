extends Area2D

signal clicked

func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_exited.connect(_on_mouse_exited)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(true)
		elif !event.pressed:
			clicked.emit(false)


func _on_mouse_exited() -> void:
	clicked.emit(false)
