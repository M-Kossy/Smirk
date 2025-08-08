extends Area2D

signal on_touch

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var disable := false:
	set(value):
		disable = value
		collision_shape_2d.disabled = value
		set_collision_mask_value(3, !value)
		visible = !value


func reset():
	disable = false

func _on_body_entered(body: Node2D) -> void:
	on_touch.emit(self, body)
