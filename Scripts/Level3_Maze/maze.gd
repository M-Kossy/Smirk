extends Area2D

signal touched
signal finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var collision_shape_2d: CollisionShape2D = $End/CollisionShape2D



func _on_body_entered(body: Node2D) -> void:
	touched.emit(body)


func _on_end(body: Node2D) -> void:
	#print("FINISH")
	finished.emit(body);

func mask():
	for node in get_children():
		if node is CollisionPolygon2D:
			node.disabled = true
	collision_shape_2d.disabled = true
	sprite_2d.visible = false

func demask():
	for node in get_children():
		if node is CollisionPolygon2D:
			node.disabled = false
	collision_shape_2d.disabled = false
	sprite_2d.visible = true
